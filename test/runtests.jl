using Graphics
using Compat
using Compat.Test
using Compat.LinearAlgebra

@testset "Geometry" begin
    ## Point-vector identity (typealias)
    @test Point(2, 1) == Vec2(2, 1)

    ## Vector operators
    @test Vec2(1, 2) + Vec2(3, 4) == Vec2(4, 6)
    @test Vec2(1, 2) - Vec2(3, 4) == Vec2(-2, -2)
    @test Vec2(1, 2) * 1 == Vec2(1, 2) # identity
    @test Vec2(1, 2) * 0 == Vec2(0, 0) # null
    @test Vec2(1, 2) * 2 == Vec2(2, 4) # scalar multiplication
    @test Vec2(1, 2) / 2 == Vec2(0.5, 1)


    ## rotation: rotate()
    @test rotate(Vec2(1, 2), π, Vec2(1, 1)).x ≈ 1
    @test rotate(Vec2(1, 2), π, Vec2(1, 1)).y ≈ 0
    @test rotate(Vec2(1, 2), 2π).x ≈ 1
    @test rotate(Vec2(1, 2), 2π).y ≈ 2

    ## Euclidean norm/magnitude: norm()
    @test norm(Vec2(1, 2)) == sqrt(5)
    @test norm(Vec2(0, 0)) == 0

    ## Bounding boxes: BoundingBox
    BBT_point_1 = Vec2(1, 1)
    BBT_point_2 = Vec2(2, 3)
    BBT_point_3 = Vec2(4, 5)
    BBT = BoundingBox(BBT_point_1, BBT_point_2, BBT_point_3)

    ### BoundingBox attributes
    @test BBT == BoundingBox(1, 4, 1, 5)
    @test height(BBT) == 4
    @test width(BBT) == 3
    @test diagonal(BBT) == 5
    @test aspect_ratio(BBT) ≈ 1.333333333333
    @test xmin(BBT) == 1
    @test xmax(BBT) == 4
    @test center(BBT) == Vec2(2.5, 3)
    @test xrange(BBT) == (1, 4)
    @test yrange(BBT) == (1, 5)

    ### BoundingBox operations
    BBT_1 = BoundingBox(2, 3, 4, 5)
    BBT_2 = BoundingBox(6, 7, 8, 9)
    BBT_3 = BoundingBox(NaN, NaN, NaN, NaN)
    BBT_4 = BoundingBox(-Inf, -Inf, -Inf, -Inf)

    #### BoundingBox (+)
    @test BBT_1 + BBT_2 == BoundingBox(2, 7, 4, 9)
    @test BBT_3 + BBT_4 == BoundingBox(-Inf, -Inf, -Inf, -Inf)

    #### BoundingBox (&)
    @test BBT_1 & BBT_2 == BoundingBox(6, 3, 8, 5)
    @test BBT_3 & BBT_4 == BoundingBox(-Inf, -Inf, -Inf, -Inf)

    #### deform()
    @test deform(BBT_1, -1, 2, -3, 4) == BoundingBox(1, 5, 1, 9)

    #### shift()
    @test shift(BBT_1, -1, 2) == BoundingBox(1, 2, 6, 7)

    #### scale()
    @test BBT_1 * 3 == BoundingBox(1, 4, 3, 6)

    #### rotate()
    BBT_3 = rotate(BBT_1, π, Point(0, 1))
    @test BBT_3.xmin ≈ -3
    @test BBT_3.ymin ≈ -3
    @test BBT_3.xmax ≈ -2
    @test BBT_3.ymax ≈ -2

    #### with_aspect_ratio()
    @test with_aspect_ratio(BBT_1, 2) == BoundingBox(2.25, 2.75, 4, 5)
    @test with_aspect_ratio(BBT_1, 0.5) == BoundingBox(2, 3, 4.25, 4.75)

    #### isinside()
    @test isinside(BBT_1, Point(2.5, 4.5))
    @test isinside(BBT_1, Point(2, 4))
    @test isinside(BBT_1, Point(1, 3)) == false
end

# using Gtk.ShortNames, Cairo

# @testset "Canvas" begin
#     win = Window() |> (cnvs = Canvas(300, 280))
#     draw(cnvs) do c
#         set_coords(getgc(cnvs), BoundingBox(0, 1, 0, 1))
#     end
#     showall(win)
#     sleep(0.5)
#     mtrx = Cairo.get_matrix(getgc(cnvs))
#     @test mtrx.xx == 300
#     @test mtrx.yy == 280
#     @test mtrx.xy == mtrx.yx == mtrx.x0 == mtrx.y0 == 0
# end
