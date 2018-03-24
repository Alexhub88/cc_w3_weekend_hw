require('pg')

class SqlRunner

  def self.run( sql, values = [] )
    begin
      db = PG.connect({ dbname: 'bookings', host: 'localhost' })
      db.prepare("bookings_query", sql)
      result = db.exec_prepared( "bookings_query", values )
    ensure
      db.close() if db != nil
    end
    return result
  end

end
