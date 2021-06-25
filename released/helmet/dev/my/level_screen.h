// MTE MK1 (la Churrera) v5.0
// Copyleft 2010-2014, 2020 by the Mojon Twins

// This code is used to display the "new level" screen. You can customize it for your game:

{
	blackout_area ();
	invalidate_viewport ();
	cpc_UpdateNow (0);
	
	pal_set (my_inks);
	
	level_str [7] = 49 + level;
	_x = 12; _y = 11; _gp_gen = level_str; print_str ();
	_x = 10; _y = 13; _gp_gen = level_names [level]; print_str ();
	
	cpc_UpdateNow (0);

	#ifdef MODE_128K
		wyz_play_sound (SFX_START);
	#else			
		AY_PLAY_SOUND (1);
	#endif

	espera_activa (100);

	blackout_area ();
	invalidate_viewport ();
	cpc_UpdateNow (0);
}
