require_relative("./db/sql_runner")
require_relative("./film")
require_relative("./customer")

class Ticket

  attr_reader :id
  attr_accessor :customer_id, :film_id, :screening_time

  def initialize(new_ticket)
    @id = new_ticket['id'].to_i if new_ticket['id']
    @customer_id = new_ticket['customer_id'].to_i
    @film_id = new_ticket['film_id'].to_i
    @screening_time = screening_time
  end

  def save()
    sql = "INSERT INTO tickets
    (customer_id, film_id)
    VALUES
    ($1, $2)
    RETURNING id"
    values = [@customer_id, @film_id]
    ticket = SqlRunner.run(sql,values).first
    @id = ticket['id'].to_i
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def customer()
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [@customer_id]
    customer = SqlRunner.run(sql, values).first
    return Customer.new(customer)
  end

  def film()
    sql = "SELECT * FROM films WHERE id = $1"
    values = [@film_id]
    film = SqlRunner.run(sql, values).first
    return Film.new(film)
  end

  def self.all()
    sql = "SELECT * FROM tickets"
    tickets_data = SqlRunner.run(sql)
    return Ticket.map_items(tickets_data)
  end

  def self.delete_all()
   sql = "DELETE FROM tickets"
   SqlRunner.run(sql)
  end

  def self.map_items(tickets_data)
    result = tickets_data.map { |ticket| Ticket.new(ticket) }
    return result
  end

  def update()
    sql = "UPDATE tickets
    SET (customer_id, film_id) = ($1, $2)
    WHERE id = $3"
    values = [@customer_id, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def self.number_of_tickets_bought_by_customer(customer)
    sql = "SELECT * FROM tickets WHERE customer_id = $1"
    values = [customer.id]
    tickets = SqlRunner.run(sql, values)
    tickets_for_this_customer = Ticket.map_items(tickets)
    return tickets_for_this_customer.length
  end

  def self.number_of_customers_with_tickets_for_film(film)
    sql = "SELECT * FROM tickets WHERE film_id = $1"
    values = [film.id]
    result = SqlRunner.run(sql, values)
    tickets = Ticket.map_items(result)
    customer_id_array = tickets.map {|ticket| ticket.customer_id}
    return customer_id_array.uniq.length  #uniq in case customer bought more than 1 ticket
  end

end
