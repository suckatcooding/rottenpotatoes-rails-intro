class Movie < ActiveRecord::Base

    def self.get_allratings(ratings)
        return Movie.where(:rating => ratings)
    end	
end
