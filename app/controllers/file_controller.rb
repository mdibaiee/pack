class FileController < ApplicationController
  def show
    name = params[:name]

    send_file Rails.root.join('files/' + name)
  end
end
