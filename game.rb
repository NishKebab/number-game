gem 'pry'
require 'pry'

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
			puts "You've won in %s  guesses and the number was: %s" % [@guesses, @num]
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
		@guess = {0 => [1,2,3,4,5,6,7,8,9],
		 		  1 => [0,1,2,3,4,5,6,7,8,9],
		 		  2 => [0,1,2,3,4,5,6,7,8,9],
		 		  3 => [0,1,2,3,4,5,6,7,8,9]}
		@guess_prob = {}

		 @turn = 1
		 @guesses = []
		 @outputs = []
		 @all_values = []
	end
	def remove_numbers(numbers)
		numbers = transform_guess numbers	 
		 @guess.each do |k,v|
 			@guess[k] = @guess[k] - numbers
 		end
	end
	def remove_digit(numbers)
		numbers = transform_guess numbers
			
		 numbers.each_with_index do |o,i|
			@guess[i].delete o
		end
	end
	def add_digit(numbers)
		numbers = transform_guess numbers
 		numbers.each_with_index do |n,i|
 			if @guess[i].include? n && @guess[i].count(n) < 5
 				@guess[i] << n 
 			end
 		end
	end
	def transform_guess(guess)
		guess = guess.split('')
 		guess.map!{|n| n.to_i} 
 		guess
	end

	def enumrate_possible_values
		values = []
		num = []
		last_guess = @guesses.last
		out_temp = @outputs.last
		out_temp = Array.new(4){|i| out_temp[i] || ""}
		out_perm = out_temp.permutation.to_a.uniq
		out_perm.each do |out|
			temp_guess = @guess.clone
			out.each_with_index do |o,i|
				if o == "o"					
					temp = last_guess.split("")
					temp.delete_at(i)
					temp_guess[i] = temp 
					temp_guess[i] = temp_guess[i].map{|a| a.to_i}
				elsif o == "-"
					temp_guess[i] = Array.new(1){last_guess.split("")[i].to_i}
				elsif o == ""
					temp_guess[i] = temp_guess[i] - Array.new(1){last_guess.split("")[i].to_i}
				end	
			end
			temp_guess[0].each do |g0|
				temp_guess[1].each do |g1|
					temp_guess[2].each do |g2|                
						temp_guess[3].each do |g3|
							num = [] 
							num << g0<<g1<<g2<<g3
							values << num.join.to_i if num.size > 3
						end
					end
				end
			end
		end
		if @all_values.size > 0
			@all_values << (@all_values.last & values.flatten.uniq)
		else
			@all_values << values.flatten.uniq
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
		elsif output == ["o","o","o","o"]
			@guess.each do [k,v]
				@guess[k] = (v & @guesses[i])
			end
		end
		enumrate_possible_values if @turn > 1
	end

	def guess(output)
		@outputs << output if @turn > 1
		process_history if @turn > 1
		@guesses << select_num
		@turn = @turn + 1

		return @guesses.last

	end
	
	def select_num
		if @turn == 1
			return "1122"
		elsif @turn == 2
			return "4433"
		#elsif @turn == 3
			#return "9999"
		elsif @turn > 2
			t_g = @guesses.map{|g| g.to_i}
			if @turn%2==0
			num = (@all_values.last - t_g).last
			else
			num = (@all_values.last - t_g).first
		end
			return num.to_s
				

		elsif (1==2)
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



