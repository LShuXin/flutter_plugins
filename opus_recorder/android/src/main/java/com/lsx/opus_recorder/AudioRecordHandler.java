package com.lsx.opus_recorder;

import android.media.AudioFormat;
import android.media.AudioRecord;
import android.os.Message;
import top.oply.opuslib.OpusRecorder;

public class AudioRecordHandler implements Runnable {
	private volatile boolean isRecording;
	private final Object mutex = new Object();
	private static final int frequency = 8000;
	private static final int audioEncoding = AudioFormat.ENCODING_PCM_16BIT;
	private static final float MAX_SOUND_RECORD_TIME = 60.0f;
	public static int packagesize = 160;// 320
	private String fileName = null;
	private float recordTime = 0;
	private long startTime = 0;
	private long endTime = 0;
	private long maxVolumeStart = 0;
	private long maxVolumeEnd = 0;
	private static AudioRecord recordInstance = null;
	private OpusRecorder opusRecorder;
	private io.flutter.plugin.common.MethodChannel channel;

	public AudioRecordHandler(String fileName, io.flutter.plugin.common.MethodChannel channel) {
		super();
		this.fileName = fileName;
		this.channel = channel;
	}

	public void run() {
		try {
			synchronized (mutex) {
				while (!this.isRecording) {
					try {
						mutex.wait();
					} catch (InterruptedException e) {
						throw new IllegalStateException("Wait() interrupted!", e);
					}
				}
			}
			try {
				new Thread(new Runnable() {
					@Override
					public void run() {
						OpusRecorder.getInstance().startRecording(fileName);
					}
				}).start();

				// Wait a bit for the recorder to be initialized
				try {
					Thread.sleep(1000);
				} catch (InterruptedException e) {
				}

				recordTime = 0;
				startTime = System.currentTimeMillis();
				maxVolumeStart = System.currentTimeMillis();

				final AudioRecord monitor;
				int bufferSize = AudioRecord.getMinBufferSize(16000, AudioFormat.CHANNEL_IN_MONO,
						AudioFormat.ENCODING_PCM_16BIT);
				AudioRecord tempMonitor = null;
				try {
					tempMonitor = new AudioRecord(android.media.MediaRecorder.AudioSource.MIC, 16000,
							AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT, bufferSize);
					tempMonitor.startRecording();
					android.util.Log.d("OpusRecorder", "Monitor AudioRecord started");
				} catch (Exception e) {
					android.util.Log.e("OpusRecorder", "Monitor AudioRecord failed to start", e);
				}
				monitor = tempMonitor;

				final short[] monitorBuffer = new short[bufferSize / 2];

				while (this.isRecording) {
					endTime = System.currentTimeMillis();
					recordTime = (float) ((endTime - startTime) / 1000.0f);
					if (recordTime >= MAX_SOUND_RECORD_TIME) {
						break;
					}

					if (monitor != null && monitor.getRecordingState() == AudioRecord.RECORDSTATE_RECORDING) {
						int readLen = monitor.read(monitorBuffer, 0, monitorBuffer.length);
						if (readLen > 0) {
							double sum = 0;
							for (int i = 0; i < readLen; i++) {
								sum += (double) monitorBuffer[i] * monitorBuffer[i];
							}
							double rms = Math.sqrt(sum / readLen);
							// Normalize RMS (max for 16-bit is 32767) to a 0-100 scale roughly
							final double volume = (rms / 327.67);

							if (System.currentTimeMillis() - maxVolumeStart >= 100) {
								maxVolumeStart = System.currentTimeMillis();
								if (channel != null) {
									new android.os.Handler(android.os.Looper.getMainLooper()).post(new Runnable() {
										@Override
										public void run() {
											channel.invokeMethod("onAmplitudeChanged", volume);
										}
									});
								}
							}
						}
					} else {
						try {
							Thread.sleep(100);
						} catch (InterruptedException e) {
						}
					}
				}

				if (monitor != null) {
					try {
						monitor.stop();
						monitor.release();
					} catch (Exception e) {
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				OpusRecorder.getInstance().stopRecording();
				if (recordInstance != null) {
					recordInstance.stop();
					recordInstance.release();
					recordInstance = null;
				}
			}
		} catch (Exception e) {

		}

	}

	private void setMaxVolume(short[] buffer, int readLen) {
		try {
			if (maxVolumeEnd - maxVolumeStart < 100) {
				return;
			}
			maxVolumeStart = maxVolumeEnd;
			int max = 0;
			for (int i = 0; i < readLen; i++) {
				if (Math.abs(buffer[i]) > max) {
					max = Math.abs(buffer[i]);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public float getRecordTime() {
		return recordTime;
	}

	public void setRecordTime(float len) {
		recordTime = len;
	}

	public void setRecording(boolean isRec) {
		synchronized (mutex) {
			this.isRecording = isRec;
			if (this.isRecording) {
				mutex.notify();
			}
		}
	}

	public boolean isRecording() {
		synchronized (mutex) {
			return isRecording;
		}
	}
}
