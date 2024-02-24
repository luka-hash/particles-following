// Copyright © 2024- Luka Ivanović
// This code is licensed under the terms of 2-clause BSD licence (see LICENCE for details)

use fmt;
use math;
use math::random;
use types::c;

type Vec2 = struct {
	x: f32,
	y: f32,
};

type Color = struct {
	r: u8,
	g: u8,
	b: u8,
	a: u8,
};

type Particle = struct {
	pos: Vec2,
	vel: Vec2,
	color: Color,
};

const WHITE = Color {
	r = 255,
	g = 255,
	b = 255,
	a = 255,
};
const BLACK = Color {
	r = 0,
	g = 0,
	b = 0,
	a = 255,
};

@symbol("InitWindow") fn InitWindow(int, int, *c::char) void;
fn init_window(width: int, height: int, title: str) void = {
	InitWindow(width, height, c::fromstr(title));
};
@symbol("CloseWindow") fn close_window() void;
@symbol("WindowShouldClose") fn window_should_close() bool;
@symbol("BeginDrawing") fn begin_drawing() void;
@symbol("EndDrawing") fn end_drawing() void;
@symbol("SetTargetFPS") fn set_target_fps(int) void;
@symbol("ClearBackground") fn clear_background(Color) void;
@symbol("DrawFPS") fn draw_fps(int, int) void;
@symbol("DrawPixelV") fn draw_pixel_v(Vec2, Color) void;
@symbol("GetMousePosition") fn get_mouse_position() Vec2;
@symbol("IsKeyPressed") fn is_key_pressed(int) bool;

const screen_width = 800;
const screen_height = 800;

def particle_count = 20000;

export fn main() void = {
	let particles: [particle_count]nullable *Particle = [null...];
	let r = random::init(0);
	for (let i = 0z; i<particle_count;i+=1) {
		particles[i] = new_random_particle(screen_width, screen_height, &r);
	};
	init_window(screen_width, screen_height, "Particles");
	set_target_fps(60);
	for (!window_should_close()) {
		if (is_key_pressed('Q')) {
			break;
		};
		const mouse_pos = get_mouse_position();
		for (let i = 0z; i<particle_count;i+=1) {
			attract(particles[i] as *Particle, &mouse_pos, 5.0);
			do_friction(particles[i] as *Particle, 0.98);
			move(particles[i] as *Particle, screen_width, screen_height);
		};
		begin_drawing();
		clear_background(WHITE);
		for (let i = 0z; i<particle_count;i+=1) {
			draw_particle(particles[i]: *Particle);
		};
		draw_fps(5,5);
		end_drawing();
	}; 
	close_window();
	for (let i = 0z; i<particle_count;i+=1) {
		free(particles[i]);
	};
};

fn distance(v1: Vec2, v2: Vec2) f32 = {
	const dx = v1.x - v2.x;
	const dy = v1.y - v2.y;
	return math::sqrtf64(((dx*dx)+(dy*dy)): f64): f32;
};

fn normal(v1: Vec2, v2: Vec2) Vec2 = {
	let dist = distance(v1,v2);
	if (dist == 0.0) {
		dist = 1.0;
	};
	const dx = v1.x - v2.x;
	const dy = v1.y - v2.y;
	let normal: Vec2 = Vec2 {
		x = dx*(1.0/dist),
		y = dy*(1.0/dist),
	};
	return normal;
};

fn attract(p: *Particle, v: *Vec2, multiplier: f32) void = {
	const dist = maxf32(distance((*p).pos, *v), 0.5);
	const normal = normal((*p).pos, *v);
	(*p).vel.x -= normal.x/dist;
	(*p).vel.y -= normal.y/dist;
};

fn do_friction(p: *Particle, amount: f32) void = {
	(*p).vel.x *= amount;
	(*p).vel.y *= amount;
};

fn move(p: *Particle, width: int, height: int) void = {
	(*p).pos.x += (*p).vel.x;
	(*p).pos.y += (*p).vel.y;
	if ((*p).pos.x<0.0){
		(*p).pos.x += width: f32;
	};
	if ((*p).pos.x>=(width: f32)){
		(*p).pos.x -= width: f32;
	};
	if ((*p).pos.y<0.0){
		(*p).pos.y += height: f32;
	};
	if ((*p).pos.y>=(height: f32)){
		(*p).pos.y -= height: f32;
	};
};

fn new_random_particle(width: int, height: int, r: *random::random) *Particle = {
	return alloc(Particle {
		pos = Vec2 {
			x = (random::f64rand(r)*((width-1): f32)): f32,
			y = (random::f64rand(r)*((height-1): f32)): f32,
		},
		vel = Vec2 {
			x = ((random::f64rand(r)-0.5)*2.0): f32,
			y = ((random::f64rand(r)-0.5)*2.0): f32,
		},
		color = BLACK,
	});
};

fn draw_particle(p: *Particle) void = {
	draw_pixel_v((*p).pos, (*p).color);
	return void;
};

fn maxf32(a: f32, b: f32) f32 = {
	if (a>b) {
		return a;
	};
	return b;
};
