# 导入必要的库
import re

# 初始化开销统计字典
overhead_stats = {
    "driver": 0,
    "filesys": 0,
    "aio": 0,
    "syscall": 0,
    "block": 0,
    "blaze": 0,
    'interrupt':0,
    "other": 0
}

# 初始化对应字符串字典
category_strings = {
    "driver": [],
    "filesys": [],
    "aio": [],
    "syscall": [],
    "block": [],
    "blaze": [],
    "interrupt": [],
    "other": []
}

# 定义关键字列表
syscall_keywords = [
    '__get_user_4','__get_user_8'
]

aio_keywords = [
    'io_submit_one','__virt_addr_valid','mutex_lock','copy_user_generic_unrolled','lookup_ioctx',
    'do_io_getevents','get_reqs_available','__check_object_size',
]
filesys_keywords = [
    'bio_check_pages_dirty', '_raw_read_lock', 'bio_iov_iter_get_pages', 
    'bio_init', 'kmem_cache_free', 'internal_get_user_pages_fast', 'bio_uninit', 'bio_free', 
    'bio_alloc_bioset', 'iov_iter_get_pages', 'try_grab_compound_head', 'set_page_dirty_lock',
    'bio_set_pages_dirty','kmem_cache_alloc','lockref_get_not_zero','lockref_put_return',
    'kmem_cache_alloc_trace','kfree','unlock_page','atime_needs_update','down_read',
    'mempool_alloc','__radix_tree_lookup','iov_iter_advance','iov_iter_npages','page_mapping',
    'set_page_dirty','bvec_split_segs','dget_parent','__fsnotify_parent','touch_atime',
    'iov_iter_alignment','radix_tree_lookup','get_user_pages_fast','jbd2_transaction_committed',
    'gup_pgd_range','fget','dput','fsnotify',
]
block_keywords = [
    'pvclock_clocksource_read','percpu_counter_add_batch','sbitmap_queue_clear',
    'ktime_get','sbitmap_get','__rq_qos_throttle','__sbitmap_get_word','__rq_qos_done_bio',
    '__rq_qos_track','__rq_qos_done','__rq_qos_issue','__sbitmap_queue_get',
    'll_back_merge_fn',
]
driver_keywords = [
    '_raw_spin_lock','sg_next','blk_bvec_map_sg','sg_init_table',
]



# 读取并处理数据
with open('/home/zxd/blaze/analysis/perf/haslab13.txt', 'r') as file:
    for line in file:
        # 使用正则表达式匹配和提取数据
        match = re.match(r'^\s*([\d.]+)%\s+(\d+)\s+\[([kK.])\]\s+(.*)', line)
        if match:
            overhead = float(match.group(1))
            category = match.group(3)
            function_name = match.group(4)
            # print(function_name)

            # 根据条件分类开销
            if category == 'k':
                if any(keyword in function_name for keyword in filesys_keywords):
                    overhead_stats['filesys'] += overhead
                    category_strings['filesys'].append(function_name)
                elif any(keyword in function_name for keyword in aio_keywords):
                    overhead_stats['aio'] += overhead
                    category_strings['aio'].append(function_name) 
                elif any(keyword in function_name for keyword in block_keywords):
                    overhead_stats['block'] += overhead
                    category_strings['block'].append(function_name) 
                elif any(keyword in function_name for keyword in driver_keywords):
                    overhead_stats['driver'] += overhead
                    category_strings['driver'].append(function_name)               
                elif any(keyword in function_name for keyword in syscall_keywords):
                    overhead_stats['syscall'] += overhead
                    category_strings['syscall'].append(function_name)
                elif 'nvme' in function_name or 'dma' in function_name:
                    overhead_stats['driver'] += overhead
                    category_strings['driver'].append(function_name)
                elif 'file' in function_name or 'iomap' in function_name or 'ext4' in function_name:
                    overhead_stats['filesys'] += overhead
                    category_strings['filesys'].append(function_name)
                elif 'aio' in function_name:
                    overhead_stats['aio'] += overhead
                    category_strings['aio'].append(function_name)
                elif 'sys' in function_name or 'SYS' in function_name:
                    overhead_stats['syscall'] += overhead
                    category_strings['syscall'].append(function_name)
                elif 'bio' in function_name or 'blk' in function_name:
                    overhead_stats['block'] += overhead
                    category_strings['block'].append(function_name)
                elif 'irq' in function_name or 'interrupt' in function_name:
                    overhead_stats['interrupt'] += overhead
                    category_strings['interrupt'].append(function_name)
                else:
                    overhead_stats['other'] += overhead
                    category_strings['other'].append(function_name)
            elif category == '.':
                    overhead_stats['blaze'] += overhead
                    category_strings['blaze'].append(function_name)


# 打印结果
with open('output_haslab13.txt', 'w') as output_file:
    for category, total_overhead in overhead_stats.items():
        output_file.write(f"{category} 开销总和: {total_overhead}%\n")
        output_file.write(f"{category} 对应的函数:\n")
        for function_name in category_strings[category]:
            output_file.write(f"  {function_name}\n")
        output_file.write("\n")
# for category, total_overhead in overhead_stats.items():
#     print(f"{category} 开销总和: {total_overhead}")
#     print(f"{category} 对应的函数:")
#     for function_name in category_strings[category]:
#         print(f"  {function_name}")
#     print("\n")
