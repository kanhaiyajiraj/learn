class TopicsController < ApplicationController
	include Secured
  	before_action :logged_in_using_omniauth?, only: [:toggle_follow]

	def index
	end

	def show
		@topic = Topic.from_param(params[:id])
		if current_user
			@user_topics = current_user.user_topics
			@does_follow = @user_topics.find { |ut| (ut.topic_id == @topic.id) && (ut.action == 'follow') }
		end
		@item_type_items = @topic.items.group_by(&:item_type)
	end

	def toggle_follow
		@topic = Topic.from_param(params[:id])
		if current_user
			@user_topics = current_user.user_topics
			@topic_action = @user_topics.find { |ut| ut.topic_id == @topic.id }
			if @topic_action
				@topic_action.destroy
			else
				@user_topics.create(topic: @topic, action: "follow")
			end
		end
		redirect_to @topic
	end

	def search
		results = Topic.where("name like ?", "%#{params[:q]}%")
		render :json => results.as_json(only: [:id, :name])
	end
end
