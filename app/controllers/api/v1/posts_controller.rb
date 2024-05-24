module Api::V1
  class PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post, only: [ :show, :edit, :update, :destroy ]

    # GET /posts
    def index
      @posts = Post.all
      render json: @posts
    end

    # GET /posts/:id
    def show
      render json: @post
    end

    # POST /posts
    def create
      @post = Post.new(post_params)

      if @post.save
        attach_media_files
        render json: @post, status: :created
      else
        render json: @post.errors, status: :unprocessable_entity
      end
    end

    # PUT /posts/:id
    def update
      if @post.update(post_params)
        attach_media_files
        render json: @post
      else
        render json: @post.errors, status: :unprocessable_entity
      end
    end

    # DELETE /posts/:id
    def destroy
      @post.destroy
      render json: { message: 'post was successfuly destroyed.'}
    end

    private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.permit(:caption, media_files: []).merge(user: current_user)
    end

    def attach_media_files
      params[:media_files].each do |file|
        @post.media_files.attach(file)
      end if params[:media_files]
    end

  end
end