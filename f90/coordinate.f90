module coordinate
    use parameters
    type cartesian!�ѿ�������ϵ
        real*16::x
        real*16::y
        real*16::z
    end type
    type geodetic!�������ϵ
        real*16::b
        real*16::l
        real*16::h
    endtype
    type topocentric!վ�ĵ�ƽ����ϵ
        real*16::n
        real*16::e
        real*16::u
    endtype
    type topopolar!վ�ļ�����ϵ
        real*16::s
        real*16::e
        real*16::a
    endtype
    
    contains
    subroutine geotocar(car,geo)!�������ϵת�ѿ�������ϵ
    type(cartesian)::car
    type(geodetic)::geo
    real*16 n
    n=am/sqrt(1-e2*sin(geo%b)*sin(geo%b))
    car%x=(n+geo%h)*cos(geo%b)*cos(geo%l)
    car%y=(n+geo%h)*cos(geo%b)*sin(geo%l)
    car%z=(n*(1-e2)+geo%h)*sin(geo%b)
    endsubroutine
    
    subroutine cartogeo(car,geo)!�ѿ�������ϵת�������ϵ
    type(cartesian)::car
    type(geodetic)::geo
    real*16 w,n,bb
    geo%b=0
    geo%l=atan2(car%y,car%x)
    bb=atan2(car%z,sqrt(car%x*car%x+car%y*car%y))
    do while(abs(bb-geo%b)>0.00000000000001)
    geo%b=bb
    w=sqrt(1-e2*sin(geo%b)*sin(geo%b))
    n=am/w
    bb=atan2((car%z+n*e2*sin(geo%b)),sqrt(car%x*car%x+car%y*car%y))
    geo%h=car%z/sin(geo%b)-n*(1-e2)
    enddo

    end subroutine
    
    subroutine cartotop(car1,car2,top)!�ѿ�������ϵתվ�ĵ�ƽ����ϵ
    type(cartesian)::car1,car2
    type(topocentric)::top
    type(geodetic)::geo
    call cartogeo(car1,geo)
    top%n=-sin(geo%b)*cos(geo%l)*(car2%x-car1%x)-sin(geo%b)*sin(geo%l)*(car2%y-car1%y)+cos(geo%b)*(car2%z-car1%z)
    top%e=-sin(geo%l)*(car2%x-car1%x)+cos(geo%l)*(car2%y-car1%y)
    top%u=cos(geo%b)*cos(geo%l)*(car2%x-car1%x)+cos(geo%b)*sin(geo%l)*(car2%y-car1%y)+sin(geo%b)*(car2%z-car1%z)
    end subroutine
    
    subroutine toptocar(car1,car2,top)!վ�ĵ�ƽ����ϵת�ѿ�������ϵ
    type(cartesian)::car1,car2
    type(topocentric)::top
    type(geodetic)::geo
    call cartogeo(car1,geo)
    car2%x=-sin(geo%b)*cos(geo%l)*top%n-sin(geo%l)*top%e+cos(geo%b)*cos(geo%l)*top%u+car1%x
    car2%y=-sin(geo%b)*sin(geo%l)*top%n+cos(geo%l)*top%e+cos(geo%b)*sin(geo%l)*top%u+car1%y
    car2%z=cos(geo%b)*top%n+sin(geo%b)*top%u+car1%z
    endsubroutine
    
    subroutine toptopop(top,pop)!վ�ĵ�ƽ����ϵתվ�ļ�����ϵ
    type(topocentric)::top
    type(topopolar)::pop
    pop%s=sqrt(top%n*top%n+top%e*top%e+top%u*top%u)
    pop%e=asin(top%u/pop%s)
    pop%a=atan2(top%e,top%n)
    endsubroutine
    
    subroutine poptotop(top,pop)!վ�ļ�����ϵתվ�ĵ�ƽ����ϵ
    type(topocentric)::top
    type(topopolar)::pop
    top%n=pop%s*cos(pop%e)*cos(pop%a)
    top%e=pop%s*cos(pop%e)*sin(pop%a)
    top%u=pop%s*sin(pop%e)
    endsubroutine
    
    
    end module
