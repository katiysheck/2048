asect 0xff00
matrix:

rsect move_down

slide_col_down_offset>
	ldi r0, 12 # адрес нижней ячейки
	ldi r1, 12 # тот же адресasect 0xff00
matrix:

rsect move_down

# нужен для ситуации вроде этой:
# -slide> 2 2 2 2 
# -merge> 0 2 0 2 
# -f_slide> 0 0 2 2 
final_slide_col_down> 
	ldi r0, 12 # адрес нижней ячейки
	ldi r1, 12 
	ldi r3, 0
	while
		cmp r1, 0
	stays ge
		ldb r5, r1, r2
		if
			tst r2
		is nz
			stb r5, r1, r3 # clear tile
			stb r5, r0, r2 # move non-zero tile to the first
			sub r0, 4 # сдвигаем r0 на следующую ячейку
		fi
		sub r1, 4 # сдвигаем r1 на следующую ячейку
	wend
	rts

slide_col_down>
	
	ldi r3, 0

	# обнуление строк
	add r5, 0x30
	ldi r0, 12
	ldi r1, 0
	while
		cmp r1, 4
	stays lt
		stb r5, r0, r3
		sub r0, 4
		inc r1
	wend
	sub r5, 0x30

	ldi r0, 12 # адрес нижней ячейки
	ldi r1, 12 # тот же адрес
	ldi r7, 0
	while
		cmp r1, 0
	stays ge
		ldb r5, r1, r2
		if
			tst r2
		is nz
			ldi r6, 1 # флаг - поменяли матрицу
			add r5, 0x30
			stb r5, r1, r3 # clear tile
			stb r5, r0, r2 # move non-zero tile to the first
			sub r5, 0x30
			sub r0, 4 # сдвигаем r0 на следующую ячейку
		else
			inc r7
		fi
		sub r1, 4 # сдвигаем r1 на следующую ячейку
	wend
	rts

merge_col_down>
	ldi r0, 12 # адрес первой ячейки
	ldi r1, 8 # адрес второй ячейки
	ldi r7, 0

	add r5, 0x30

	while
		cmp r1, 0
	stays ge
		ldb r5, r0, r2
		ldb r5, r1, r3
		if
			cmp r2, r3
		is eq
			if
				tst r2
			is nz
				ldi r7, 1
				ldi r6, 1 # set flag that matrix has changed
				add r2, 1
				
				stb r5, r0, r2
				ldi r3, 0
				stb r5, r1, r3
			fi
		fi
		sub r0, 4 # переходим на следующую ячейку
		sub r1, 4 # переходим на следующую ячейку
	wend

	sub r5, 0x30

	rts

process_col_down>
	jsr slide_col_down
	if
		cmp r7, 4
	is eq
		rts
	fi
	jsr merge_col_down
	if
		tst r7
	is z
		rts
	fi
			# jsr slide_col_down
	rts

move_down>
	ldi r6, 0
	# r6 has matrix changed
	ldi r5, matrix # адрес обрабатываемого сполбца
	ldi r4, 0xff04 # адрес последнего столбца
	while
		cmp r5, r4
	stays lt
		jsr process_col_down

		add r5, 0x30
		jsr final_slide_col_down
		sub r5, 0x30
		
		add r5, 1 # переходим на след столб

	wend
	
	rts

end
	ldi r7, 0
	ldi r3, 0
	while
		cmp r1, 0
	stays ge
		ldb r5, r1, r2
		if
			tst r2
		is nz
			ldi r6, 1 # флаг - поменяли матрицу
			add r5, 0x30
			stb r5, r1, r3 # clear tile
			stb r5, r0, r2 # move non-zero tile to the first
			sub r5, 0x30
			sub r0, 4 # сдвигаем r0 на следующую ячейку
		else
			inc r7
		fi
		sub r1, 4 # сдвигаем r1 на следующую ячейку
	wend
	rts


slide_col_down>
	ldi r0, 12 # адрес нижней ячейки
	ldi r1, 12 # тот же адрес
	ldi r7, 0
	ldi r3, 0
	while
		cmp r1, 0
	stays ge
		ldb r5, r1, r2
		if
			tst r2
		is nz
			ldi r6, 1 # флаг - поменяли матрицу
			stb r5, r1, r3 # clear tile
			stb r5, r0, r2 # move non-zero tile to the first
			sub r0, 4 # сдвигаем r0 на следующую ячейку
		else
			inc r7
		fi
		sub r1, 4 # сдвигаем r1 на следующую ячейку
	wend
	rts

merge_col_down>
	add r5, 0x30
	ldi r0, 12 # адрес первой ячейки
	ldi r1, 8 # адрес второй ячейки
	ldi r7, 0
	while
		cmp r1, 0
	stays ge
		ldb r5, r0, r2
		ldb r5, r1, r3
		if
			cmp r2, r3
		is eq
			if
				tst r2
			is nz
				ldi r7, 1
				ldi r6, 1 # set flag that matrix has changed
				add r2, 1
				stb r5, r0, r2
				ldi r3, 0
				stb r5, r1, r3
			fi
		fi
		sub r0, 4 # переходим на следующую ячейку
		sub r1, 4 # переходим на следующую ячейку
	wend
	sub r5, 0x30
	rts

process_col_down>
	jsr slide_col_down_offset
	if
		cmp r7, 4
	is eq
		rts
	fi
	jsr merge_col_down
	if
		tst r7
	is z
		rts
	fi
	add r5, 0x30
	jsr slide_col_down
	sub r5, 0x30
	rts

move_down>
	ldi r6, 0
	# r6 has matrix changed
	ldi r5, matrix # адрес обрабатываемого сполбца
	ldi r4, 0xff04 # адрес последнего столбца
	while
		cmp r5, r4
	stays lt
		jsr process_col_down
		add r5, 1 # переходим на след столб
	wend
	rts

end
