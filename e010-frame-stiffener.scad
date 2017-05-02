$fn=100;

the_thing(
    wheel_base=65.7, // It's a stretch X actually! L=45 W=47
    arms_width=2.6,
    cage_angle=15.5,
    cage_chamfer=0.4,
    motor_diameter=6.5,
    pod_diameter=8.1,
    pod_width=4.6,
    thickness=0.6
);

module the_thing(wheel_base, arms_width, cage_angle, cage_chamfer, motor_diameter, pod_diameter, pod_width, thickness) {
    arm_length = wheel_base / 2;
    cage_height = thickness * 2;

    cage_positons = [
        [[-arm_length, 0], [0, 0, -cage_angle], [0, 0, 0]],
        [[+arm_length, 0], [0, 0, -cage_angle + 180], [0, 0, 180]],
        [[0, +arm_length], [0, 0, +cage_angle - 90], [0, 0, -90]],
        [[0, -arm_length], [0, 0, +cage_angle + 90], [0, 0, 90]],
    ];

    difference() {
        union() {
            arms(length=wheel_base, base_width=arms_width, base_height=thickness, ridge_width=thickness, ridge_height=thickness, chamfer=thickness / 3);
            for (p = cage_positons)
                translate(p[0])
                rotate(p[2])
                    translate([0, 0, cage_height / 2])
                    hull() {
                        cylinder(h=cage_height, r=pod_diameter / 2 + thickness * 1.7, center=true);
                        translate([arms_width * 1.2, 0, 0])
                            cylinder(h=cage_height, r=arms_width, center=true);
                    }
        };

        for (p = cage_positons)
            translate([0, 0, -1])
            translate(p[0])
            rotate(p[1])
            linear_extrude(cage_height + 2)
            cage_base(motor_diameter, pod_diameter, pod_width, thickness, cage_chamfer);
    }
}

module cage_base(motor_diameter, pod_diameter, pod_width, thickness, chamfer) {
    union() {
        cage_pod(pod_diameter, pod_width, chamfer);
        offset(r=-chamfer)
        union() {
            cage_pod(pod_diameter, pod_width + chamfer * 2, chamfer);
            circle(d=motor_diameter + chamfer * 2);
            translate([motor_diameter / 2.3, 0]) circle(d=motor_diameter / 2 + chamfer * 2);
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

module arms(length, base_width, base_height, ridge_width, ridge_height, chamfer) {
    union() {
       arm(length, base_width, base_height, ridge_width, ridge_height, chamfer);
       rotate([0, 0, 90]) arm(length, base_width, base_height, ridge_width, ridge_height, chamfer);
    }
}

module arm(length, base_width, base_height, ridge_width, ridge_height, chamfer) {
    rotate([90, 0, 90])
    translate([0, 0, -length / 2])
    union() {
        translate([-ridge_width / 2, base_height, 0]) cube([ridge_width, ridge_height, length]);
        translate([-base_width / 2, 0, 0]) cube([base_width, base_height, length]);
    }
}
