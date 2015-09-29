require 'mimemagic'

class FilesController < ApplicationController
  before_filter :check_auth

  def check_auth
    authenticate_or_request_with_http_basic do |username,password|
      resource = User.find_by email: username
      if resource.valid_password?(password)
        sign_in :user, resource
      end
    end
  end

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

    name = file.original_filename
    user_path = Rails.root.join('files').join(current_user.username)
    dest = File.expand_path(name, user_path)

    if not params[:replace].empty?
      @item = Item.find_by(name: name)
    elsif File.exists? dest
      duplicates = Item.where('name LIKE ?', name + '%')
      ext = File.extname(name)
      base = File.basename(name, ext) + '(' + duplicates.count.to_s + ')'
      # render plain: base and return
      name = base + ext
      dest = File.expand_path(name, user_path)
    end

    src = file.tempfile.path
    stat = File.stat src

    unless @item
      @item = Item.new
      @item.name = name
      @item.path = dest
      @item.user = current_user
      @item.size = stat.size
      @item.filetype = MimeMagic.by_path src
    end

    dest_parent = File.dirname dest
    unless File.exists? dest_parent
      FileUtils.mkdir dest_parent
    end

    if @item.save and FileUtils.mv src, dest
      if params[:from] == 'pack-client'
        render json: @item and return
      end
      redirect_to file_path(@item)
    else
      if params[:from] == 'pack-client'
        render plain: @item and return
      end
      render :new
    end
  end

  def destroy
    user = params[:user]
    name = params[:name]
    id = params[:id]

    if user and name
      user_instance = User.find_by username: user
      @item = Item.find_by user_id: user_instance.id, name: name
    else
      @item = Item.find id
    end
    @item.destroy
    FileUtils.rm @item.path

    redirect_to files_path
  end
end
