﻿package away3d.containers
			if (event.target is BitmapSession)
				_updatedSessions[event.target] = event.target;
			_viewSourceObject.screenIndices = Vector.<int>([0]);
			_viewSourceObject.screenUVTs = Vector.<Number>([0, 0, 0]);