#require 'pry'

class Meastero
	attr_accessor :history, :num, :guesses
	
	def initialize(num)
		@num = num.to_s.split('')
		@guesses = 0
		@history = []
	end

	def play(guess)
		if @guesses < 100
		@guesses = @guesses + 1
		guess = guess.to_s.split('')
		output = []
		leftovers = []
		@num.each_with_index do |digit, i|
			if digit == guess[i]
				output << "-"
			elsif 
				leftovers << digit
			end
		end
		guess.uniq.each_with_index do |digit, i|
			if leftovers.count(digit) > 0 
				leftovers.count(digit).times do 
					output << "o"
				end
			end
		end
		if output.size < 1
			output = [""]
		end
		history << {guess => output}
		#p history
		if output.count("-") == 4 
			puts "You've won in %s  guesses" % @guesses
			@guesses = 10000
			return "Winner"
		elsif @guesses > 99
			puts "You've lost"
			puts history
			p @num
			return output
		else
			return output
		end

	end
end
end

class Guess
	attr_accessor :guess
	def initialize
		@guess = {1 => [1,2,3,4,5,6,7,8,9],
		 2 => [0,1,2,3,4,5,6,7,8,9],
		 3 => [0,1,2,3,4,5,6,7,8,9],
		 4 => [0,1,2,3,4,5,6,7,8,9]}
		 @turn = 1
		 @guesses = []
		 @outputs = []
	end
	def remove_numbers(numbers)
		 numbers = numbers.split('')
 		 numbers.map!{|n| n.to_i} 		 
		 @guess.each do |k,v|
 			@guess[k] = @guess[k] - numbers
 		end
	end
	def remove_digit(numbers)
		 numbers = numbers.split('')
 		 numbers.map!{|n| n.to_i} 	
		 numbers.each_with_index do |o,i|
			@guess[i+1].delete o
		end
	end
	def add_digit(numbers)
		numbers = numbers.split('')
 		numbers.map!{|n| n.to_i} 
 		numbers.each_with_index do |n,i|
 			if @guess[i+1].include? n && @guess[i+1].count(n) < 5
 				@guess[i+1] << n 
 			end
 		end
	end



	def process_history
		i = @outputs.size - 1
		output = @outputs[i]
		if output[0] == ""
			remove_numbers @guesses[i]
		elsif !output.include? "-"
			remove_digit @guesses[i]
		elsif !output.include? "o" && output.count("-") > 2
			add_digit @guesses[i]
		end
	end

	def guess(output)
		@outputs << output if @turn > 1
		process_history if @turn > 1
		@guesses << select_num
		@turn = @turn + 1

		return @guesses[@guesses.size-1]

	end
	
	def select_num
		if @turn == 1
			return "1122"
		elsif @turn == 2
			return "4433"
		#elsif @turn == 3
			#return "9999"

		else
		 	begin 
				num = ""
				@guess.each do |k,v|
			  		num << v.sample().to_s
				end
				if num.to_i < 1000
					break
				end
			end while(@guesses.include? num)
			return num
		end
	end

end

totals = []

(1000..9999).each do |i|
	output = []
	game = Meastero.new(i)
	guesser = Guess.new
	counter = 0
	begin
 		output = game.play(guesser.guess(output))
 		counter = counter + 1
 	end until output == "Winner" 
 	totals << counter
end

p totals.inject{ |sum, el| sum + el }.to_f / totals.size



