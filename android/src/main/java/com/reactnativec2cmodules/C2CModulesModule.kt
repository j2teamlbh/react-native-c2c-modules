  package com.reactnativec2cmodules

  import android.view.View
  import com.facebook.react.bridge.ReactApplicationContext
  import com.facebook.react.bridge.ReactContextBaseJavaModule
  import com.facebook.react.bridge.ReactMethod
  import com.facebook.react.bridge.UiThreadUtil

  class C2CModulesModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

      override fun getName(): String {
          return "C2CModules"
      }

    @ReactMethod
    fun onFullScreen() {
      UiThreadUtil.runOnUiThread {
        currentActivity!!.window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_LAYOUT_STABLE or
              View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY or
              View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
      }
    }

    @ReactMethod
    fun offFullScreen() {
      UiThreadUtil.runOnUiThread { currentActivity!!.window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_LAYOUT_STABLE or
              View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION or
              View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN }
    }

  }
