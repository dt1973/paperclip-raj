Forem::Post.class_eval do
  has_many :photos

  accepts_nested_attributes_for :photos
end 
