package com.cicada.player.app;


import android.app.Application;

import com.aliyun.externalplayer.exo.ExternPlayerExo;
import com.cicada.player.CicadaExternalPlayer;
import com.cicada.player.app.util.SharedPreferenceUtils;


public class PlayerApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        SharedPreferenceUtils.init(getApplicationContext());

        CicadaExternalPlayer.registerExternalPlayer(new ExternPlayerExo());
    }
}
