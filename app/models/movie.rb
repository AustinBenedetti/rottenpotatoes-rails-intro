class Movie < ActiveRecord::Base

  # function to get ratings
  def self.get_ratings 
    ratings = ['G','PG','PG-13','R']
    return ratings
  end
  
  # return checked rating keys
  def self.with_ratings ratings
    where(rating: ratings.keys)
  end

end