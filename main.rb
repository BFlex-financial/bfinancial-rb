require 'net/http'
require 'uri'
require 'json'

def createPayment(key, data)
  url = URI.parse('http://127.0.0.1:8080/payment/create')
  http = Net::HTTP.new(url.host, url.port)
  request = Net::HTTP::Post.new(url.request_uri)
  request['Authorization-key'] = key
  request.content_type = 'application/json'
  request.body = data
  response = http.request(request)
  parsed_response = JSON.parse(response.body)
  parsed_response
end

class Payment
  def create(client_key, info)
    response = createPayment(client_key, info.to_json)
    response['data']
  end
end

class JSONConverter
  def to_json(*_args)
    JSON.generate(to_hash)
  end
end

class Pix < JSONConverter
  attr_accessor :method, :payer_email, :amount

  def initialize
    @method = "Pix"
    @payer_email = nil
    @amount = nil
  end

  def to_hash
    {
      'method' => @method,
      'payer_email' => @payer_email,
      'amount' => @amount
    }
  end

  def set_payer_email(email)
    @payer_email = email
    self
  end

  def set_amount(amount)
    @amount = amount
    self
  end
end

class Card < JSONConverter
  attr_accessor :payer_email, :payer_name, :payer_cpf, :method, :amount, :expiration_year, :expiration_month, :cvv, :number

  def initialize
    @method = "Card"
    @amount = nil

    @cvv = nil
    @number = nil

    @payer_email = nil
    @payer_name = nil
    @payer_cpf = nil

    @expiration_year = nil
    @expiration_month = nil
  end

  def to_hash
    {
      'method' => @method,
      'amount' => @amount,

      'payer_email' => @payer_email,
      'payer_name' => @payer_name,
      'payer_cpf' => @payer_cpf,

      'cvv' => @cvv,
      'number' => @number,
      'expiration_year' => @expiration_year,
      'expiration_month' => @expiration_month
    }
  end

  def set_payer_email(email)
    @payer_email = email
    self
  end

  def set_payer_cpf(cpf)
    @payer_cpf = cpf
    self
  end

  def set_payer_name(name)
    @payer_name = name
    self
  end

  def set_expiration_year(year)
    @expiration_year = year
    self
  end

  def set_cvv(cvv)
    @cvv = cvv
    self
  end

  def set_number(number)
    @number = number
    self
  end

  def set_expiration_month(month)
    @expiration_month = month
    self
  end

  def set_amount(amount)
    @amount = amount
    self
  end
end

class ClientModels
  def self.pix
    Pix
  end
  def self.card
    Card
  end
end

class Models
  def self.client
    ClientModels
  end
end

class Derive
  def self.payments
    Payment.new
  end

  def self.models
    Models
  end
end

module Client
  def self.login(auth_key)
    { 'collect' => Derive, 'instance' => auth_key }
  end
end
