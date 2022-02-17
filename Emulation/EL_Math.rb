module Collider

    ELLIPTIC = 1

    ELLIPSE_1 = SDC::CollisionShapeEllipse.new
    ELLIPSE_2 = SDC::CollisionShapeEllipse.new

	def self.test_collision(entity_1, entity_2)
        if entity_1.box == ELLIPTIC && entity_2.box == ELLIPTIC then
            ELLIPSE_1.semiaxes = SDC.xy(entity_1.xsize, entity_1.ysize)
            ELLIPSE_2.semiaxes = SDC.xy(entity_2.xsize, entity_2.ysize)

            SDC::Collider.test(ELLIPSE_1, SDC.xy(entity_1.x, entity_1.y-entity_1.ysize), ELLIPSE_2, SDC.xy(entity_2.x, entity_2.y-entity_2.ysize))
        end
    end

end