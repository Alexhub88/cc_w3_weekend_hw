require_relative("./db/sql_runner")
require_relative("./film")

class Screening

  attr_reader :id
  attr_accessor :time, :film_id

  def initialize(new_screening)
    @id = new_screening['id'].to_i if new_screening['id']
    @time = new_screening['time']
    @film_id = new_screening['film_id'].to_i
  end

  def save()
    sql = "INSERT INTO screenings
    (time, film_id)
    VALUES
    ($1, $2)
    RETURNING id"
    values = [@time, @film_id]
    screening = SqlRunner.run(sql,values).first
    @id = screening['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM screenings"
    screenings_data = SqlRunner.run(sql)
    return Screening.map_items(screenings_data)
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    values = []
    SqlRunner.run(sql, values)
  end

  def self.film_times(film)
    sql = "SELECT * FROM screenings WHERE film_id = $1"
    values = [film.id]
    screenings_hash = SqlRunner.run(sql, values)
    return Screening.map_items(screenings_hash)
  end

  def self.map_items(screenings_hash)
    screenings = screenings_hash.map { |screening| Screening.new(screening) }
    return screenings
  end

end
