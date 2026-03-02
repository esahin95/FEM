function varargout = size(obj, varargin)

[varargout{1:nargout}] = size(obj.Internal, varargin{:});