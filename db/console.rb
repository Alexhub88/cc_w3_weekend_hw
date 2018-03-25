require_relative( '../film' )
require_relative( '../customer' )
require_relative( '../ticket' )
require_relative( '../screening' )

require( 'pry-byebug' )

Ticket.delete_all()
Film.delete_all()
Customer.delete_all()
Screening.delete_all()

customer1 = Customer.new({ 'name' => 'Matthew', 'funds' => '5' })
customer1.save()
customer2 = Customer.new({ 'name' => 'Mark', 'funds' => '45' })
customer2.save()
customer3 = Customer.new({ 'name' => 'Luke', 'funds' => '99' })
customer3.save()

film1 = Film.new({ 'title' => '2001: A Space Odyssey', 'price' => '66'})
film1.save()
film2 = Film.new({ 'title' => 'The Beach', 'price' => '88'})
film2.save()
film3 = Film.new({ 'title' => 'Gringo', 'price' => '50'})
film3.save()

screening1 = Screening.new({ 'time' => '15:30:00', 'film_id' => film1.id})
screening1.save()
screening2 = Screening.new({ 'time' => '10:45:00', 'film_id' => film1.id})
screening2.save()
screening3 = Screening.new({ 'time' => '18:25:00', 'film_id' => film2.id})
screening3.save()
screening4 = Screening.new({ 'time' => '19:45:00', 'film_id' => film3.id})
screening4.save()
screening5 = Screening.new({ 'time' => '14:00:00', 'film_id' => film3.id})
screening5.save()

ticket1 = Ticket.new({ 'customer_id' => customer1.id, 'film_id' => film1.id, 'screening_id' => screening2.id})
ticket1.save()
ticket2 = Ticket.new({ 'customer_id' => customer3.id, 'film_id' => film1.id, 'screening_id' => screening1.id})
ticket2.save()
ticket3 = Ticket.new({ 'customer_id' => customer1.id, 'film_id' => film2.id, 'screening_id' => screening2.id})
ticket3.save()
ticket4 = Ticket.new({ 'customer_id' => customer2.id, 'film_id' => film2.id, 'screening_id' => screening2.id})
ticket4.save()
ticket5 = Ticket.new({ 'customer_id' => customer3.id, 'film_id' => film3.id, 'screening_id' => screening1.id})
ticket5.save()
ticket6 = Ticket.new({ 'customer_id' => customer3.id, 'film_id' => film3.id, 'screening_id' => screening1.id})
ticket6.save()
ticket7 = Ticket.new({ 'customer_id' => customer3.id, 'film_id' => film1.id, 'screening_id' => screening2.id})
ticket7.save()
ticket8 = Ticket.new({ 'customer_id' => customer3.id, 'film_id' => film3.id, 'screening_id' => screening2.id})
ticket8.save()

p Ticket.all()
puts ""
puts ""
# p Film.all()
# p Customer.all()
# p Screening.all()

# p ticket4.customer()
# p customer2.id
# p film2.id
# p ticket4.film()
#
# p customer3
#
# customer3.funds = '24'
# customer3.update()
# p customer3
#
# p film2
#
# film2.title = 'Event Horizon'
# film2.update()
# p film2
#
# p ticket1.customer
# puts ""
# p ticket1
# puts ""
# ticket1.customer_id = customer2.id
# ticket1.update()
#
# p ticket1.customer
# puts ""
# p ticket1
#
# p film2.customers_with_tickets_for_the_film()
#
# p customer3.films_booked_by_this_customer()
# puts ""
# p Ticket.all()
 puts ""

customer3.buys_ticket_to_see(film2, screening3)
p Ticket.all()
#
# puts ""
# p Ticket.number_of_tickets_bought_by_customer(customer3)
# puts ""
#
# puts ""
# p Ticket.number_of_customers_with_tickets_for_film(film3)
# puts ""
#
# puts ""
# p Screening.film_times(film3)
# puts ""
#
# puts ""
# p Ticket.most_popular_screening_for_film(film3)
# puts ""
