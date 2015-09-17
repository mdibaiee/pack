class ItemController < ApplicationController
  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
  end

  def create
    file = params[:item][:file]

    dest = File.expand_path(file.original_filename, Rails.root.join('files/'))
    src = file.tempfile.path

    @item = Item.new
    @item.name = file.original_filename
    @item.url = 'file/' + file.original_filename
    @item.path = dest

    if @item.save and FileUtils.mv src, dest
      redirect_to @item
    else
      render :new
    end
  end
end
