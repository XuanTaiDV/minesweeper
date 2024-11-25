module MinesBoards
  class CreateService
    attr_reader :mines_board
    def initialize(params)
      @params = params
    end

    def generate_mines_board!
      build_mine_board
      build_matrix
      create_mines_board!
    end

    private

    attr_reader :params

    def build_mine_board
      @mines_board = MinesBoard.new(
        name: permitted_params[:name],
        email_address: permitted_params[:email_address]
      )
    end

    def build_matrix
      mines_board.matrix = mines_board_matrix!(height:, width:, mines_quantity:)
    end

    def create_mines_board!
      mines_board.save!
    end

    def mines_board_matrix!(height:, width:, mines_quantity:)
      raise "Invalid value" if height.zero? || width.zero?
      raise "Invalid bomb quantity" if height * width < mines_quantity

      hash = {}
      mines_stock = Array.new(mines_quantity, 1)
      mines_per_round, remainder = distribute_mines(width, mines_quantity)

      height.times.each do |col|
        if remainder != 0 && [true, false, true, false].sample
          number_of_mines = mines_per_round + remainder
          remainder = 0
        else
          number_of_mines = mines_per_round
        end

        mines_places = mines_stock.pop(number_of_mines)
        safe_places = Array.new(width - mines_places.length, 0)
        hash[col] = (mines_places + safe_places).shuffle
      end

      hash
    end

    # everyone should have ability to ka-boom!
    def distribute_mines(row, mines_quantity)
      if row >= mines_quantity
        [1, 0]
      else
        mines_quantity.divmod(row)
      end
    end

    def permitted_params
      @permitted_params ||= params.require(:mines_board)
                                  .permit(:name, :email_address, :width, :height, :mines_quantity)
    end

    def height
      permitted_params[:height].to_i
    end

    def width
      permitted_params[:width].to_i
    end

    def mines_quantity
      permitted_params[:mines_quantity].to_i
    end
  end
end
