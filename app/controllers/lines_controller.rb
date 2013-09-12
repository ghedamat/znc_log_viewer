class LinesController < ApplicationController

  def index
    if search && params[:commit] == 'Search' && !search[:keyword].blank?
      @lines = channel.lines.search_message(search[:keyword]).ascending.paginate(:page => params[:page])
    else
      @lines = channel.lines.messages.ascending.paginate(:page => params[:page])
    end
  end

  private

  def search
    params.fetch(:search, nil)
  end

  def channel
    @channel ||= if params[:search]
      Channel.find(search[:channel])
    else
      Channel.first
    end
  end


end
