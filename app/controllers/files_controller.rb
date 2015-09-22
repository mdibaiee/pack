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
    warden.custom_failure! if performed?
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

    if File.exists? dest
      duplicates = Item.where('name LIKE ?', name + '%')
      base = File.basename(name) + duplicates.count.to_s
      # render plain: base and return
      name = base + File.extname(name)
      dest = File.expand_path(name, user_path)
    end

    src = file.tempfile.path
    stat = File.stat src

    @item = Item.new
    @item.name = name
    @item.path = dest
    @item.user = current_user
    @item.size = stat.size
    @item.filetype = MimeMagic.by_path src

    dest_parent = File.dirname dest
    unless File.exists? dest_parent
      FileUtils.mkdir dest_parent
    end

    if @item.save and FileUtils.mv src, dest
      if params[:from] == 'pack-client'
        render plain: "ok" and return
      end
      redirect_to file_path(@item)
    else
      if params[:from] == 'pack-client'
        render plain: "ok" and return
      end
      render :new
    end
  end

  def destroy
    @item = Item.find params[:id]

    @item.destroy
    FileUtils.rm @item.path

    redirect_to files_path
  end
end
