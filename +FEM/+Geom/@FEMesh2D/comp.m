function [B, wdV] = comp(obj, gid, eid)

B = reshape(obj.Bfl * obj.XYP(:,:,gid,eid)', 4, []);

wdV = obj.wdV(gid,eid);