package com.mydreams.android.utils;

public class ManualResetEvent
{
	private final Object monitor = new Object();
	private volatile boolean open = false;

	public ManualResetEvent(boolean open)
	{
		this.open = open;
	}

	public void reset()
	{//close stop
		open = false;
	}

	public void set()
	{//open start
		synchronized (monitor)
		{
			open = true;
			monitor.notifyAll();
		}
	}

	public void waitOne() throws InterruptedException
	{
		synchronized (monitor)
		{
			while (!open)
			{
				monitor.wait();
			}
		}
	}

	public boolean waitOne(long milliseconds) throws InterruptedException
	{
		synchronized (monitor)
		{
			if (open)
			{
				return true;
			}

			monitor.wait(milliseconds);
			return open;
		}
	}
}
