require_relative("./db/sql_runner")
require_relative("./film")
require_relative("./customer")
require_relative("./screening")

class Ticket

  attr_reader :id
  attr_accessor :customer_id, :film_id, :screening_id

  def initialize(new_ticket)
    @id = new_ticket['id'].to_i if new_ticket['id']
    @customer_id = new_ticket['customer_id'].to_i
    @film_id = new_ticket['film_id'].to_i
    @screening_id = new_ticket['screening_id'].to_i
  end

  def save()
    sql = "INSERT INTO tickets
    (customer_id, film_id, screening_id)
    VALUES
    ($1, $2, $3)
    RETURNING id"
    values = [@customer_id, @film_id, @screening_id]
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
    SET (customer_id, film_id, screening_id) = ($1, $2, $3)
    WHERE id = $4"
    values = [@customer_id, @film_id, @screening_id, @id]
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

  def self.most_popular_screening_for_film(film)

    sql = "SELECT * FROM tickets WHERE film_id = $1"
    values = [film.id]
    result = SqlRunner.run(sql, values)
    tickets = Ticket.map_items(result)

    screening_id_array = tickets.map {|ticket| ticket.screening_id}
    freq = screening_id_array.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    commonest_screening_id = screening_id_array.max_by { |v| freq[v] }

    sql = "SELECT * FROM screenings WHERE id = $1"
    values = [commonest_screening_id]
    result = SqlRunner.run(sql, values)
    result[0]["id"].to_i
    commonest_screening = Screening.new(result[0])

    return commonest_screening.time

    end

end
