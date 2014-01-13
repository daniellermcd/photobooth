class AlbumsController < ApplicationController
  force_ssl unless Rails.env.development?

  before_action :set_album, only: [:photobooth, :show, :edit, :update]
  before_action :set_username, only: [:photobooth, :show]
  before_action :authenticate_user!
  before_filter :validate_user, only: [:show, :photobooth]

  def create
    @album = current_user.albums.new safe_album_params
    @album.save ? redirect_to("/albums/#{@album.id}/photobooth") : render(:new)
  end

  def edit
  end

  def index
    @albums = current_user.albums
  end

  def new
    @album = Album.new
  end

  def photobooth
  end

  def share
  end

  def show
    @album_photos = @album.photos.reverse.map { |photo| photo.url }
  end

  def update
    @album.update safe_album_params
    redirect_to @album
  end

  private
  def set_username
    @username = @album.user.email[/[^@]+/]
  end

  def set_album
    @album = Album.find params[:id]
  end

  def validate_user
    album_owner_id = Album.find(params[:id]).user.id
    redirect_to root_path unless current_user and current_user.id == album_owner_id
  end

  def safe_album_params
    safe_album_params = params.require(:album).permit(:title)
  end
end
