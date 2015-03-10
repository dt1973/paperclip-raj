Forem::TopicsController.class_eval do
  def new
    authorize! :create_topic, @forum
    @topic = @forum.topics.build
    post = @topic.posts.build
    post.photos.build
  end

protected
  def topic_params
    params.require(:topic).permit(:subject, :posts_attributes => [ :text, {:photos_attributes => [:attachment]} ])
  end
end
