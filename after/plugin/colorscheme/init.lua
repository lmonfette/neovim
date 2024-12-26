print('after/plugin/colorscheme')
function ColorTheCode(colorscheme)
	colorscheme = colorscheme or 'horizon-extended'

	vim.cmd.colorscheme(colorscheme)
	
	vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
	vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
end

ColorTheCode()
