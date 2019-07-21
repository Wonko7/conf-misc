--[[
Clock Rings by Linux Mint (2011) reEdited by despot77

This script draws percentage meters as rings, and also draws clock hands if you want! It is fully customisable; all options are described in the script. This script is based off a combination of my clock.lua script and my rings.lua script.

IMPORTANT: if you are using the 'cpu' function, it will cause a segmentation fault if it tries to draw a ring straight away. The if statement on line 145 uses a delay to make sure that this doesn't happen. It calculates the length of the delay by the number of updates since Conky started. Generally, a value of 5s is long enough, so if you update Conky every 1s, use update_num>5 in that if statement (the default). If you only update Conky every 2s, you should change it to update_num>3; conversely if you update Conky every 0.5s, you should use update_num>10. ALSO, if you change your Conky, is it best to use "killall conky; conky" to update it, otherwise the update_num will not be reset and you will get an error.

To call this script in Conky, use the following (assuming that you save this script to ~/scripts/rings.lua):
lua_load ~/scripts/clock_rings.lua
lua_draw_hook_pre clock_rings

Changelog:
+ v1.0 -- Original release (30.09.2009)
v1.1p -- Jpope edit londonali1010 (05.10.2009)
*v 2011mint -- reEdit despot77 (18.02.2011)
]]


-- fg_col=0x268bd2
-- fg_col=0xEEEEEE
-- fg_col=0xAAAAAA
--
-- fg_col=0xcb4b16
-- bg_col=0x002b36
--
-- fg_col=0xcccccc
-- clock_fg_col=0xcccccc
-- clock_fg_col=0xcb4b16
--clock_bg_col=0x002b36
--bg_col=0x002b36
function getHostname()
  local f = io.popen ("/bin/hostname")
  local hostname = f:read("*a") or ""
  f:close()
  hostname =string.gsub(hostname, "\n$", "")
  return hostname
end
hostname = getHostname()

-- DEF
fg_col=0x67C8FF
bg_col=0xffffff

bg_alpha=0.2
fg_alpha=0.8

clock_fg_col=fg_col
clock_bg_col=bg_col

if hostname == 'yggdrasill' then
  clock_r=93
  clock_x=126
  clock_y=335

  thickness=10
  gap_thickness=4
  rad=50
  toty=clock_y + 210
  totx=179
  deltay=140
  show_seconds=true

  clock_hand_thickness_s = 3
  clock_hand_thickness_m = 5
  clock_hand_thickness_h = 7

  wlan = 'wlp2s0'
else
  clock_r=50
  clock_x=75
  clock_y=200

  thickness=6
  gap_thickness=2
  rad=33
  toty=clock_y + 135
  totx=110
  deltay=100
  show_seconds=true

  clock_hand_thickness_s = 2
  clock_hand_thickness_m = 3
  clock_hand_thickness_h = 4

  wlan = 'wlp4s0'
end

settings_table = {
    {
        -- Edit this table to customise your rings.
        -- You can create more rings simply by adding more elements to settings_table.
        -- "name" is the type of stat to display; you can choose from 'cpu', 'memperc', 'fs_used_perc', 'battery_used_perc'.
        name='time', -- HOUR
        -- "arg" is the argument to the stat type, e.g. if in Conky you would write ${cpu cpu0}, 'cpu0' would be the argument. If you would not use an argument in the Conky variable, use ''.
        -- arg='%I.%M',
        arg='hour',
        -- "max" is the maximum value of the ring. If the Conky variable outputs a percentage, use 100.
        max=12,
        -- "bg_colour" is the colour of the base ring.
        bg_colour=clock_bg_col,
        -- "bg_alpha" is the alpha value of the base ring.
        bg_alpha=bg_alpha, -- FIXME make this globals. was 0.2
        -- "fg_colour" is the colour of the indicator part of the ring.
        fg_colour=clock_fg_col,
        -- "fg_alpha" is the alpha value of the indicator part of the ring.
        fg_alpha=0.7,
        -- "x" and "y" are the x and y coordinates of the centre of the ring, relative to the top left corner of the Conky window.
        x=clock_x, y=clock_y,
        -- "radius" is the radius of the ring.
        radius=clock_r,
        -- "thickness" is the thickness of the ring, centred around the radius.
        thickness=thickness,
        -- "start_angle" is the starting angle of the ring, in degrees, clockwise from top. Value can be either positive or negative.
        start_angle=0,
        -- "end_angle" is the ending angle of the ring, in degrees, clockwise from top. Value can be either positive or negative, but must be larger than start_angle.
        end_angle=360
    },
    {
        name='time',
        arg='%M.%S',
        max=60,
        bg_colour=clock_bg_col,
        bg_alpha=bg_alpha,
        fg_colour=clock_fg_col,
        fg_alpha=0.8,
        x=clock_x, y=clock_y,
        radius=clock_r + thickness + gap_thickness, -- minutes
        thickness=thickness,
        start_angle=0,
        end_angle=360
    },
    {
        name='time',
        arg='%S',
        max=60,
        bg_colour=clock_bg_col,
        bg_alpha=bg_alpha,
        fg_colour=clock_fg_col,
        fg_alpha=0.9,
        x=clock_x, y=clock_y,
        radius=clock_r + (thickness + gap_thickness) * 2,
        thickness=thickness,
        start_angle=0,
        end_angle=360
    },
    -- {
    --     name='time',
    --     arg='%d',
    --     max=31,
    --     bg_colour=bg_col,
    ----     bg_alpha=bg_alpha,
    --     bg_alpha=bg_alpha,
    --     fg_colour=0x268bd2,
    --     fg_alpha=0.8,
    --     x=100, y=150,
    --     radius=70,
    --     thickness=thickness,
    --     start_angle=-90,
    --     end_angle=90
    -- },
    -- {
    --     name='time',
    --     arg='%m',
    --     max=12,
    --     bg_colour=bg_col,
    ----     bg_alpha=bg_alpha,
    --     bg_alpha=bg_alpha,
    --     fg_colour=0x268bd2,
    --     fg_alpha=1,
    --     x=100, y=150,
    --     radius=76,
    --     thickness=thickness,
    --     start_angle=-90,
    --     end_angle=90
    -- },
    -- {
    --     name='batt',
    --     arg='BATT0',
    --     max=100,
    --     bg_colour=bg_col,
    ----     bg_alpha=bg_alpha,
    --     bg_alpha=bg_alpha,
    --     fg_colour=0x268bd2,
    --     fg_alpha=0.8,
    --     x=60, y=300,
    --     radius=25,
    --     thickness=thickness,
    --     start_angle=-90,
    --     end_angle=180
    -- },
    {
        name='cpu',
        arg='cpu0',
        max=100,
        bg_colour=bg_col,
        bg_alpha=bg_alpha,
        fg_colour=fg_col,
        fg_alpha=fg_alpha,
        x=totx, y=toty,
        radius=rad,
        thickness=thickness,
        start_angle=-90,
        end_angle=270
    },
    {
        name='memperc',
        arg='',
        max=100,
        bg_colour=bg_col,
        bg_alpha=bg_alpha,
        fg_colour=fg_col,
        fg_alpha=fg_alpha,
        x=totx, y=(toty + 1 * deltay),
        radius=rad,
        thickness=thickness,
        start_angle=-90,
        end_angle=270
    },
    {
        name='swapperc',
        arg='',
        max=100,
        bg_colour=bg_col,
        bg_alpha=bg_alpha,
        fg_colour=fg_col,
        fg_alpha=fg_alpha,
        x=totx, y=(toty + 1 * deltay),
        radius=rad - thickness - gap_thickness,
        thickness=thickness,
        start_angle=-90,
        end_angle=270
    },
    -- {
    --     name='swapperc',
    --     arg='',
    --     max=100,
    --     bg_colour=bg_col,
    ----     bg_alpha=bg_alpha,
    --     bg_alpha=bg_alpha,
    --     fg_colour=0x268bd2,
    --     fg_alpha=fg_alpha,
    --     x=60, y=370,
    --     radius=25,
    --     thickness=thickness,
    --     start_angle=-90,
    --     end_angle=180
    -- },
    {
        name='fs_used_perc',
        arg='/',
        max=100,
        bg_colour=bg_col,
        bg_alpha=bg_alpha,
        fg_colour=fg_col,
        fg_alpha=fg_alpha,
        x=totx, y=(toty + 2 * deltay),
        radius=rad,
        thickness=thickness,
        start_angle=-90,
        end_angle=270
    },
    {
        name='downspeedf',
        arg=wlan,
        max=1800,
        bg_colour=bg_col,
        bg_alpha=bg_alpha,
        fg_colour=fg_col,
        fg_alpha=fg_alpha,
        x=totx, y=(toty + 4 * deltay),
        radius=rad,
        thickness=thickness,
        start_angle=-90,
        -- end_angle=180 3/4
        end_angle=270 -- full circle
    },
        {
        name='upspeedf',
	arg=wlan,
        max=1800,
        bg_colour=bg_col,
        bg_alpha=bg_alpha,
        fg_colour=fg_col,
        fg_alpha=fg_alpha,
        x=totx, y=(toty + 4 * deltay),
        radius=rad - thickness - gap_thickness,
        thickness=thickness,
        start_angle=-90,
        -- end_angle=180 3/4
        end_angle=270 -- full circle
    },
    {
        name='Sound',
	arg='!conky',
        max=150,
        bg_colour=bg_col,
        bg_alpha=bg_alpha,
        fg_colour=fg_col,
        fg_alpha=fg_alpha,
        x=totx, y=(toty + 3 * deltay),
        radius=rad,
        thickness=thickness,
        start_angle=-90,
        end_angle=270
    },
}

-- Use these settings to define the origin and extent of your clock.


require 'cairo'

function os.capture(cmd)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  return s
end

function rgb_to_r_g_b(colour, alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function ang_to_pct(angle)
	return (angle % (2 * math.pi)) / (2 * math.pi)
end

function draw_ring(cr, t, pt)
    local w, h=conky_window.width, conky_window.height

    local xc, yc, ring_r, ring_w, sa, ea=pt['x'], pt['y'], pt['radius'], pt['thickness'], pt['start_angle'], pt['end_angle']
    local bgc, bga, fgc, fga=pt['bg_colour'], pt['bg_alpha'], pt['fg_colour'], pt['fg_alpha']

    local angle_0=sa*(2*math.pi/360)-math.pi/2
    local angle_f=ea*(2*math.pi/360)-math.pi/2
    local t_arc=t*(angle_f-angle_0)
    t_arc = math.min(t_arc, 1*(angle_f-angle_0))

    -- t_arc = modpi(t_arc)


    -- Draw background ring

    cairo_arc(cr, xc, yc, ring_r, angle_0, angle_f)
    cairo_set_source_rgba(cr, rgb_to_r_g_b(bgc, bga))
    cairo_set_line_width(cr, ring_w)
    cairo_stroke(cr)

    -- Draw indicator ring

    cairo_arc(cr, xc, yc, ring_r, angle_0, (angle_0+t_arc))
    -- cairo_arc(cr, xc, yc, ring_r, angle_0, angle_0+t_arc)
    cairo_set_source_rgba(cr, rgb_to_r_g_b(fgc, fga))
    cairo_stroke(cr)
end

function draw_clock_hands(cr, pt, xc, yc)
    local secs, mins, hours, secs_arc, mins_arc, hours_arc
    local xh, yh, xm, ym, xs, ys
    -- local file = io.open("/tmp/lol", "a")

    secs=os.date("%S")
    mins=os.date("%M")
    hours=os.date("%I")

    secs_arc=((2*math.pi/60)*secs)
    mins_arc=((2*math.pi/60)*mins+secs_arc/60)
    hours_arc=((2*math.pi/12)*hours+mins_arc/12)

    -- file:write("hours: ")
    -- file:write(hours)
    -- file:write(" : ")
    -- file:write(mins)
    -- file:write("\n")
    -- file:close()

    -- Draw hour hand

    xh=xc+(clock_r * 1.3/3)*math.sin(hours_arc)
    yh=yc-(clock_r * 1.3/3)*math.cos(hours_arc)
    cairo_move_to(cr, xc, yc)
    cairo_line_to(cr, xh, yh)

    cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND)
    cairo_set_line_width(cr, clock_hand_thickness_h)

    --cairo_set_source_rgba(cr, 0.79, 0.29, 0.08, 1.0)
    --cairo_set_source_rgba(cr, 0.79, 0.29, 0.08, 1.0)
    cairo_set_source_rgba(cr, rgb_to_r_g_b(clock_fg_col, 0.8))
    -- cairo_set_source_rgba(cr, rgb_to_r_g_b(clock_fg_col, pt['fg_alpha']))
    cairo_stroke(cr)

   -- settings_table[1]['pct'] = (hours_arc % (2 * math.pi) / (2 * math.pi);
    settings_table[1]['pct'] = ang_to_pct(hours_arc)

    -- Draw minute hand

    xm=xc+(clock_r * 1.8/3)*math.sin(mins_arc)
    ym=yc-(clock_r * 1.8/3)*math.cos(mins_arc)
    cairo_move_to(cr, xc, yc)
    cairo_line_to(cr, xm, ym)

    cairo_set_line_width(cr, clock_hand_thickness_m)
    cairo_stroke(cr)

    -- settings_table[2]['pct'] = mins_arc / (2 * math.pi);
    settings_table[2]['pct'] = ang_to_pct(mins_arc)

    -- Draw seconds hand

    if show_seconds then
        xs=xc+(clock_r * 2.1/3)*math.sin(secs_arc)
        ys=yc-(clock_r * 2.1/3)*math.cos(secs_arc)
        cairo_move_to(cr, xc, yc)
        cairo_line_to(cr, xs, ys)

        cairo_set_line_width(cr, clock_hand_thickness_s)
        cairo_stroke(cr)

	--settings_table[3]['pct'] = secs_arc / (2 * math.pi);
	settings_table[3]['pct'] = ang_to_pct(secs_arc)
    end
end

function conky_clock_rings()
    local function setup_rings(cr, pt)
        local str=''
        local value=0

        if pt['arg'] ~= '!conky' then
          str = string.format('${%s %s}', pt['name'], pt['arg'])
          str = conky_parse(str)

          value = tonumber(str)
          pct = value/pt['max']
        else
          -- only sound right now:
          value = os.capture('~/conf/misc/scripts/conky-sound.sh')
          pct = value / pt['max']
        end

        draw_ring(cr, pct, pt)
        --draw_ring(cr, 100, pt)
    end

    -- Check that Conky has been running for at least 5s

    if conky_window==nil then return end
    local cs=cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)

    local cr=cairo_create(cs)

    local updates=conky_parse('${updates}')
    update_num=tonumber(updates)


    draw_clock_hands(cr, settings_table[0], clock_x, clock_y)
    cairo_set_line_cap(cr, CAIRO_LINE_CAP_BUTT)

    if update_num>5 then
        for i in pairs(settings_table) do
	    if i < 4 then
		draw_ring(cr, settings_table[i]['pct'], settings_table[i])
		--draw_ring(cr, 100, settings_table[i])
	    else
		setup_rings(cr, settings_table[i])
	    end
        end
    end
end
