package cn.rongcloud.rtc.wrapper.flutter;

import android.os.Handler;
import android.os.Looper;

import io.flutter.plugin.common.MethodChannel.Result;

/**
 * @author panmingda
 * @date 2021/6/9
 */
final class MainThreadPoster {

    private MainThreadPoster() {
    }

    static void post(Runnable runnable) {
        if (Looper.getMainLooper() == Looper.myLooper()) {
            runnable.run();
        } else {
            handler.post(runnable);
        }
    }

    static void success(Result result) {
        success(result, null);
    }

    static void success(final Result result, final Object object) {
        post(new Runnable() {
            @Override
            public void run() {
                result.success(object);
            }
        });
    }

    static void notImplemented(final Result result) {
        post(new Runnable() {
            @Override
            public void run() {
                result.notImplemented();
            }
        });
    }

    private static final Handler handler = new Handler(Looper.getMainLooper());
}
