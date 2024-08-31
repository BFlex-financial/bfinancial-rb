require '../main.rb'

connection = Client.login("admin")
client = connection['collect']  
instance = connection['instance']

payments = client.payments  
models = client.models  

pix = models.client.pix.new
  .set_amount(22)
  .set_payer_email("test@gmail.com")

puts payments.create(instance, pix)