module Collider

    ELLIPTIC = 1

	def self.test_collision(entity_1, entity_2)
        if entity_1.box == ELLIPTIC && entity_2.box == ELLIPTIC then
            self.elliptic(entity_1.xsize, entity_1.ysize, entity_2.xsize, entity_2.ysize, entity_1.x-entity_2.x, entity_1.y-entity_1.ysize-entity_2.y+entity_2.ysize)
        end
    end

    def self.elliptic(first_a, first_b, second_a, second_b, xdiff, ydiff)
        a_ = first_a
        b_ = first_b
        c_ = second_a
        d_ = second_b
        dx_ = xdiff
        dy_ = ydiff
        
        a = a_*a_
        b = b_*b_
        c = c_*c_
        d = d_*d_
        dx = dx_*dx_
        dy = dy_*dy_

        return false if [dx,dy].max > 2*(a+c) # Exclude impossible collisions

        # TODO: Why won't these work?
        #coeff_0 = (a*b).to_f
        #coeff_1 = (-a*b-b*c-a*d+b*dx+a*dy).to_f
        #coeff_2 = (b*c+a*d+c*d-d*dx-c*dy).to_f
        #coeff_3 = (c*d).to_f

        coeff_0 = 1.0/(c*d)
        coeff_1 = (-a*b-b*c-a*d+b*dx+a*dy)/(a*b*c*d)
        coeff_2 = (b*c+a*d+c*d-d*dx-c*dy)/(a*b*c*d)
        coeff_3 = -1.0/(a*b)
        
        # Lower limit is the sign of the function at lower infinity
        lower_limit = (coeff_3.abs > 0.0 ? -coeff_3 : (coeff_2.abs > 0.0 ? coeff_2 : (coeff_1.abs > 0.0 ? -coeff_1 : coeff_0)))

        # Upper limit is the value of the function at zero
        upper_limit = coeff_0

        # Coefficients of the derivative function
        deriv_0 = coeff_1
        deriv_1 = 2*coeff_2
        deriv_2 = 3*coeff_3

        # Discriminant of the derivative
        discr_deriv = deriv_1*deriv_1 - 4*deriv_2*deriv_0

        if discr_deriv < 0.0 then
            # Function has no extrema and can therefore have only up to one negative real root
            return true
        else
            # Roots of the derivative
            denom = 1.0 / (2*deriv_2)
            sqrt_term = Math::sqrt(discr_deriv) * denom
            add_term = -deriv_1 * denom
            e_1_r = add_term - sqrt_term
            e_2_r = add_term + sqrt_term

            e_1 = e_1_r
            e_2 = e_2_r

            if e_1_r > e_2_r then
                e_1 = e_2_r
                e_2 = e_1_r
            end

            if e_1 >= 0.0 then
                # Lower extremum is bigger than f(0), so only one sign change can happen before that
                return true
            else
                if e_2 >= 0.0 then
                    # If the lower limit or upper limit have the same sign as the function value on e_1, only one more sign change before 0 can happen
                    return (lower_limit * upper_limit <= 0.0)
                else
                    # Otherwise calculate the values at the extrema
                    e_1_2 = e_1 * e_1
                    e_1_3 = e_1_2 * e_1

                    f_e_1 = coeff_0 + coeff_1 * e_1 + coeff_2 * e_1_2 + coeff_3 * e_1_3

                    e_2_2 = e_2 * e_2
                    e_2_3 = e_2_2 * e_2

                    f_e_2 = coeff_0 + coeff_1 * e_2 + coeff_2 * e_2_2 + coeff_3 * e_2_3

                    # Count overall sign changes
                    if e_1 < e_2 then
                        return (lower_limit * f_e_1 > 0.0 && upper_limit * f_e_2 > 0.0)
                    elsif e_2 < e_1 then
                        return (lower_limit * f_e_2 > 0.0 && upper_limit * f_e_1 > 0.0)
                    elsif e_1 == e_2 then
                        # TODO: Check borderline cases
                        return false
                    end
                end
            end
        end
    end

end