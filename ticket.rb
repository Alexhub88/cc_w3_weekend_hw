require_relative("./db/sql_runner")
require_relative("./film")
require_relative("./customer")

class Ticket

  attr_reader :id
  attr_accessor :customer_id, :film_id

  def initialize(new_ticket)
    @id = new_ticket['id'].to_i if new_ticket['id']
    @customer_id = new_ticket['customer_id'].to_i
    @film_id = new_ticket['film_id'].to_i
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

end
