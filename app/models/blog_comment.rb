class BlogComment < ActiveRecord::Base
	attr_accessible :body, :post_id
  belongs_to :post
  belongs_to :user
end
