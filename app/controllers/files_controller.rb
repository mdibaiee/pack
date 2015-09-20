require 'mimemagic'

class FilesController < ApplicationController
  before_action :authenticate_user!

  def index
    @items = Item.where user: current_user.id
  end

  def show
    user = params[:user]
    name = params[:name]
    id = params[:id]

    if params.has_key? :download
      send_file Rails.root.join('files').join(user).join(name)
      return
    end

    if user and name
      user_instance = User.find_by username: user
      @item = Item.find_by user_id: user_instance.id, name: name
    else
      @item = Item.find id
    end
  end

  def new
  end

  def create
    file = params[:file][:file]

    dest = File.expand_path(file.original_filename, Rails.root.join('files').join(current_user.username))
    src = file.tempfile.path
    stat = File.stat src

    @item = Item.new
    @item.name = file.original_filename
    @item.path = dest
    @item.user = current_user
    @item.size = stat.size
    @item.filetype = MimeMagic.by_path src

    dest_parent = File.dirname dest
    unless File.exists? dest_parent
      FileUtils.mkdir dest_parent
    end

    if @item.save and FileUtils.mv src, dest
      redirect_to file_path(@item)
    else
      render :new
    end
  end

  def destroy
    @item = Item.find params[:id]

    FileUtils.rm @item.path and @item.destroy

    redirect_to files_path
  end
end
