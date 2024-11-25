class MinesBoardsController < ApplicationController

  def index
    @mines_board = MinesBoard.new
    @mines_boards = MinesBoard.limit(10)
  end

  def create
    service = MinesBoards::CreateService.new(params)
    service.generate_mines_board!

    redirect_to mines_board_path(service.mines_board.name_slug)
  rescue ActiveRecord::RecordInvalid
    @mines_board = service.mines_board
    @mines_boards = MinesBoard.limit(10)

    render :index
  end

  def show
    @mines_board = MinesBoard.find_by(name_slug: params[:name_slug])
  end
end
