$fn=50;

the_thing(
    wheel_base=65,
    motor_diameter=6,
    pod_diameter=7,
    pod_width=4,
    thickness=0.9,
    height=4
);

module the_thing(wheel_base, motor_diameter, pod_diameter, pod_width, thickness, height) {
    arm_length = wheel_base / 2;

    cage_positons = [
        [[-arm_length, 0], [0, 0, -15]],
        [[+arm_length, 0], [0, 0, 165]],
        [[0, +arm_length], [0, 0, -75]],
        [[0, -arm_length], [0, 0, 105]],
    ];

    difference() {
        linear_extrude(height)
        union() {
            difference() {
                arms(wheel_base, thickness);
                for (p = cage_positons)
                    translate(p[0])
                    rotate(p[1])
                    hull()
                    scale([0.9, 0.9, 0.9])
                    cage(motor_diameter, pod_diameter, pod_width, thickness);
            }
            for (p = cage_positons)
                translate(p[0])
                rotate(p[1])
                cage(motor_diameter, pod_diameter, pod_width, thickness);
        };
        translate([0, 0, 7]) cube([30, 30, 10], center=true);
    }
}

module cage(motor_diameter, pod_diameter, pod_width, thickness) {
    difference() {
        offset(r=thickness) cage_base(motor_diameter, pod_diameter, pod_width, thickness);
        cage_base(motor_diameter, pod_diameter, pod_width, thickness);
    }
}

module cage_base(motor_diameter, pod_diameter, pod_width,  thickness) {
    union() {
        difference() {
            circle(d=pod_diameter);
            translate([+pod_width / 2, -pod_diameter / 2]) square([pod_diameter, pod_diameter]);
            translate([-(pod_diameter + pod_width / 2), -pod_diameter / 2]) square([pod_diameter, pod_diameter]);
        }
        circle(d=motor_diameter);
        translate([motor_diameter / 2.4, 0]) circle(d=motor_diameter / 2);
    }
}

module arms(wheel_base, thickness) {
    bar_size = [wheel_base + thickness * 2, thickness * 3];

    offset(r = -thickness)
    union() {
        square(bar_size, center=true);
        rotate([0, 0, 90]) square(bar_size, center=true);
    }
}
