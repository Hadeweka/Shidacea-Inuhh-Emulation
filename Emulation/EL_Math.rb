module Polythree
    
    def self.solve(a, b, c, d)
        discr_0 = (b*b - 3*a*c).to_c
        discr_1 = (2*b*b*b - 9*a*b*c + 27*a*a*d).to_c
        sqrt_discr = Complex::sqrt(discr_1*discr_1 - 4.to_c*discr_0*discr_0*discr_0)
        c = Complex::cbrt((discr_1 + sqrt_discr)/2.to_c)
        ret = []
        0.upto(2) do |i|
            ret[i] = -(b.to_c + UNIT_ROOTS[i]*c.to_c + discr_0/(UNIT_ROOTS[i]*c.to_c))/(3*a).to_c
        end
        return ret
    end

end