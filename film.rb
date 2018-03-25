require_relative("./db/sql_runner")
require_relative("./customer")
require_relative("./ticket")

class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(new_film)
    @id = new_film['id'].to_i if new_film['id']
    @title = new_film['title']
    @price = new_film['price'].to_i
  end

  def save()
    sql = "INSERT INTO films
    (title, price) VALUES ($1, $2)
    RETURNING id"
    values = [@title, @price]
    film = SqlRunner.run(sql, values).first
    @id = film['id'].to_i
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM films"
    values = []
    films = SqlRunner.run(sql, values)
    result = films.map { |film| Film.new(film) }
    return result
  end

  def update()
    sql = "UPDATE films
    SET (title, price) = ($1, $2)
    WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    values = []
    SqlRunner.run(sql, values)
  end

  def self.map_items(films_data)
    result = films_data.map { |film| Film.new(film) }
    return result
  end

  def customers_with_tickets_for_the_film()
    sql = "SELECT customers.*
     FROM customers
     INNER JOIN tickets
     ON tickets.customer_id = customers.id
     WHERE film_id = $1"
     values = [@id]
     customers_data = SqlRunner.run(sql, values)
     return Customer.map_items(customers_data)
  end

end
