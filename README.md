# Ruby SDK

## Gerando pagamento com Cartão:
```rb
connection = Client.login("admin")
client = connection['collect']  
instance = connection['instance']

payments = client.payments  
models = client.models  

card = models.client.card.new
  .set_amount(22)
  .set_payer_email("test@gmail.com")
  .set_payer_cpf("12345678909")
  .set_payer_name("test")
  .set_expiration_year(2025)
  .set_expiration_month(11)
  .set_cvv("123")
  .set_number("5031433215406351")

puts payments.create(instance, card)
```

## Gerando  pagamento PIX
```rb
connection = Client.login("admin")
client = connection['collect']  
instance = connection['instance']

payments = client.payments  
models = client.models  

pix = models.client.pix.new
  .set_amount(22)
  .set_payer_email("test@gmail.com")

puts payments.create(instance, pix)
```