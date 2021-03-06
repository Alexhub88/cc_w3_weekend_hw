require_relative("./db/sql_runner")
require_relative("./film")
require_relative("./ticket")

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(new_customer)
    @id = new_customer['id'].to_i if new_customer['id']
    @name = new_customer['name']
    @funds = new_customer['funds'].to_i
  end

  def save()
    sql = "INSERT INTO customers
    (name,funds) VALUES ($1, $2)
    RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values).first
    @id = customer['id'].to_i
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM customers"
    values = []
    customers = SqlRunner.run(sql, values)
    result = customers.map { |customer| Customer.new(customer) }
    return result
  end

  def update()
    sql = "UPDATE customers
    SET (name,funds) = ($1, $2)
    WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    values = []
    SqlRunner.run(sql, values)
  end

  def self.map_items(customers_data)
    result = customers_data.map { |customer| Customer.new(customer) }
    return result
  end

  def films_booked_by_this_customer()
    sql = "SELECT films.*
     FROM films
     INNER JOIN tickets
     ON tickets.film_id = films.id
     WHERE customer_id = $1"
     values = [@id]
     films_data = SqlRunner.run(sql, values)
     return Film.map_items(films_data)
  end

  def buys_ticket_to_see(film, screening)

    if screening.tickets_available > 0
      if @funds.to_i >= film.price
        new_ticket = Ticket.new({ 'customer_id' => @id, 'film_id' => film.id, 'screening_id' => screening.id})
        new_ticket.save()
        screening.reduce_tickets_available()
        screening.update()
        @funds -= film.price
      else
        puts 'Insufficient funds to buy this ticket!'
      end
    else
      puts 'Insufficient tickets available for this performance!'
    end

  end

end
