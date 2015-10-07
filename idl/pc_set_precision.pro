; Set the precision parameters in the pc_precision common block.
;
; 14-Sep-2015/Bourdin.KIS: redesigned completely

pro pc_set_precision, precision=new, dim=dim, datadir=datadir, QUIET=QUIET

COMPILE_OPT IDL2, HIDDEN

	common pc_precision, zero, one, precision, data_type, data_bytes, type_idl

	if (size (new, /type) eq 0) then
		if (size (dim, /type) ne 8) pc_read_dim, obj=dim, datadir=datadir, /quiet
		new = strupcase (dim.precision)
	end

	if (size (new, /type) eq 0) then message, "ERROR: precision is a mandatory parameter"
	precision = strupcase (strmid (strtrim (new, 2), 0, 1))

	if (new eq 'D') then begin
		; double precision
		zero = 0.d0
		one = 1.d0
		data_type = 'double'
		data_bytes = 8
		type_idl = 4
	end else begin
		; single precision
		zero = 0.e0
		one = 1.e0
		data_type = 'real'
		data_bytes = 4
		type_idl = 5
	end
end
