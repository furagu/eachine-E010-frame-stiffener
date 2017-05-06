$fn=100;

the_thing(
    motor_to_motor_length = 45.5,
    motor_to_motor_width  = 47.5,
    arms_width            = 2.6,
    cage_angle            = 20,
    cage_chamfer          = 0.4,
    motor_diameter        = 6.5,
    pod_diameter          = 8.1,
    pod_width             = 4.6,
    thickness             = 0.6
);

module the_thing() {
    arm_length = sqrt(pow(motor_to_motor_length, 2) + pow(motor_to_motor_width, 2)) / 2;
    arm_angle = atan(motor_to_motor_width / motor_to_motor_length);

    cage_height = thickness * 2;
    cage_x = motor_to_motor_length / 2;
    cage_y = motor_to_motor_width / 2;

    cage_positons = [
        [[+cage_x, +cage_y], arm_angle,       -cage_angle],
        [[-cage_x, +cage_y], 180 - arm_angle, +cage_angle],
        [[-cage_x, -cage_y], 180 + arm_angle, -cage_angle],
        [[+cage_x, -cage_y], 360 - arm_angle, +cage_angle],
    ];

    for (p = cage_positons) {
        difference() {
            union() {
                rotate([0, 0, p[1]])
                    arm(arm_length, arms_width, thickness);

                hull() {
                    translate([p[0][0], p[0][1], thickness])
                        cylinder(h=cage_height, r=pod_diameter / 2 + thickness * 1.7, center=true);

                    rotate([0, 0, p[1]])
                    translate([arm_length * 0.83, 0, thickness])
                        cylinder(h=cage_height, r=arms_width / 2, center=true);
                }
            }

            translate([p[0][0], p[0][1], -1])
            rotate([0, 0, p[1] + p[2]])
            linear_extrude(cage_height + 2)
                cage_base(motor_diameter, pod_diameter, pod_width, thickness, cage_chamfer);
        }
    }
}

module arm(length, width, thickness) {
    translate([0, -thickness / 2, thickness])
        cube([length, thickness, thickness]);
    translate([0, -width / 2, 0])
        cube([length, width, thickness]);
}

module cage_base(motor_diameter, pod_diameter, pod_width, thickness, chamfer) {
    union() {
        cage_pod(pod_diameter, pod_width, chamfer);
        offset(r=-chamfer)
        union() {
            cage_pod(pod_diameter, pod_width + chamfer * 2, chamfer);
            circle(d=motor_diameter + chamfer * 2);
            translate([-motor_diameter / 2.3, 0]) circle(d=motor_diameter / 2 + chamfer * 2);
        }
    }
}

module cage_pod(pod_diameter, pod_width, chamfer) {
    offset(r=chamfer)
    difference() {
        circle(d=pod_diameter - chamfer * 2);
        translate([+pod_width / 2 - chamfer, -pod_diameter / 2]) square([pod_diameter, pod_diameter]);
        translate([-(pod_diameter + pod_width / 2) + chamfer, -pod_diameter / 2]) square([pod_diameter, pod_diameter]);
    }
}
