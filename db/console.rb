require_relative( '../film' )
require_relative( '../customer' )
require_relative( '../ticket' )

require( 'pry-byebug' )

Ticket.delete_all()
Film.delete_all()
Customer.delete_all()

customer1 = Customer.new({ 'name' => 'Matthew', 'funds' => '5' })
customer1.save()
customer2 = Customer.new({ 'name' => 'Mark', 'funds' => '45' })
customer2.save()
customer3 = Customer.new({ 'name' => 'Luke', 'funds' => '77' })
customer3.save()

film1 = Film.new({ 'title' => '2001: A Space Odyssey', 'price' => '66'})
film1.save()
film2 = Film.new({ 'title' => 'The Beach', 'price' => '88'})
film2.save()

ticket1 = Ticket.new({ 'customer_id' => customer1.id, 'film_id' => film1.id})
ticket1.save()
ticket2 = Ticket.new({ 'customer_id' => customer3.id, 'film_id' => film1.id})
ticket2.save()
ticket3 = Ticket.new({ 'customer_id' => customer1.id, 'film_id' => film2.id})
ticket3.save()
ticket4 = Ticket.new({ 'customer_id' => customer2.id, 'film_id' => film2.id})
ticket4.save()

p Ticket.all()
p Film.all()
p Customer.all()

p ticket4.customer()
p customer2.id
p film2.id
p ticket4.film()

p customer3

customer3.funds = '24'
customer3.update()
p customer3

p film2

film2.title = 'Event Horizon'
film2.update()
p film2

p ticket1.customer

ticket1.customer_id = customer2.id
ticket1.update()
p ticket1.customer

p film2.customers_with_tickets_for_the_film()

p customer3.films_booked_by_this_customer()


p Ticket.all()
p Film.all()
p Customer.all()
