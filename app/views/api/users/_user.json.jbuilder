json.extract! user, :id, :username, :email, :image_url, :guest_rating, :manager_rating
json.bookings user.bookings
json.madeManagerRatings user.made_manager_ratings