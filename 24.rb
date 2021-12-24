Inst = Struct.new(:opcode, :arg1, :arg2)

program = ARGF.lines.map do |line|
  Inst.new(*line.split)
end

class ALU
  attr_accessor :regs, :program

  def initialize(program)
    self.program = program
    self.regs = {}
  end

  def rvalue(val)
    if val =~ /-?\d+/
      val.to_i
    else
      regs[val] || 0
    end
  end

  def run(input)
    regs.clear
    program.each do |inst|
      case inst.opcode
      when 'inp'
        regs[inst.arg1] = input.shift
      when 'add'
        regs[inst.arg1] ||= 0
        regs[inst.arg1] += rvalue(inst.arg2)
      when 'mul'
        regs[inst.arg1] ||= 0
        regs[inst.arg1] *= rvalue(inst.arg2)
      when 'div'
        regs[inst.arg1] ||= 0
        regs[inst.arg1] /= rvalue(inst.arg2)
      when 'mod'
        regs[inst.arg1] ||= 0
        regs[inst.arg1] /= rvalue(inst.arg2)
      when 'eql'
        if (regs[inst.arg1] || 0) == rvalue(inst.arg2)
          regs[inst.arg1] = 1
        else
          regs[inst.arg1] = 0
        end
      end
    end
    regs['z']
  end

end

alu = ALU.new(program)
stage = -1
alu.program.each do |inst|
  case inst.opcode
  when 'inp'
    if stage >= 0
      puts "  z"
      puts "end\n\n"
    end
    stage += 1
    puts "def stage#{stage}(w, z)"
  when 'add'
    puts "  #{inst.arg1} += #{inst.arg2}"
  when 'mul'
    puts "  #{inst.arg1} #{inst.arg2 == '0' ? '' : '*'}= #{inst.arg2}"
  when 'div'
    puts "  #{inst.arg1} /= #{inst.arg2}"
  when 'mod'
    puts "  #{inst.arg1} %= #{inst.arg2}"
  when 'eql'
    puts "  #{inst.arg1} = (#{inst.arg1} == #{inst.arg2} ? 1 : 0)"
  end
end
puts "  z"
puts "end\n\n"
