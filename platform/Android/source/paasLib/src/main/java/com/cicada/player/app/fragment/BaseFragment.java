package com.cicada.player.app.fragment;

import androidx.fragment.app.Fragment;

public class BaseFragment extends Fragment {

    protected String mPlaySource;

    public void setPlaySource(String mPlaySource){
        this.mPlaySource = mPlaySource;
    }
}
